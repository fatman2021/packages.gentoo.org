import portage
import os
import xml.etree.ElementTree

# local_config=False tells this to ignore all changes in /etc/portage
SETTINGS = portage.config(local_config=False)

PORTTREE = portage.portagetree(settings=SETTINGS).dbapi


class Trees:
    DEFAULT = "gentoo"

    @staticmethod
    def repositories():
        return PORTTREE.getRepositories()

    # This will parse the metadata/timestamp file for the footer
    # time.strptime('Sun Aug  3 10:07:04 UTC 2014', '%a %b %d %H:%M:%S %Z %Y')


class Overlays(Trees):
    @staticmethod
    def repositories():
        return [x for x in Trees.repositories() if x != Overlays.DEFAULT]


class Repository(Trees):
    def __init__(self, repository):
        if repository not in Trees.repositories():
            raise Exception("Invalid repository %s" % repository)

        self.repository = repository

    def missing_categories(self):
        CATEGORIES = os.path.join(PORTTREE.getRepositoryPath(self.repository), 'profiles/categories')
        return not os.path.isfile(CATEGORIES)

    def categories(self):
        CATEGORIES = os.path.join(PORTTREE.getRepositoryPath(self.repository), 'profiles/categories')
        if os.path.isfile(CATEGORIES):
            return portage.util.grabfile(CATEGORIES)

        # PORTTREE.categories says it's set set when PORTTREE.cp_all() is called by anything
        # so instead of using it, we just call cp_all() and filter that way
        all_packages = PORTTREE.cp_all(trees=[PORTTREE.getRepositoryPath(self.repository)])
        categories = set()
        for package in all_packages:
            category, _ = package.split('/')
            categories.add(category)

        return sorted(categories, key=str.lower)

    # TODO: reading parents should be based off of metadata/layout.conf
    def category_description(self, category):
        # Note: portage.xml.metadata.MetaDataXML's descriptions() does not (yet) support
        # the lang attribute, so we can't use it

        # For the gentoo tree, both of these will have the same result
        OVERLAY_METADATA = os.path.join(PORTTREE.getRepositoryPath(self.repository), '%s/metadata.xml' % category)
        if os.path.exists(OVERLAY_METADATA):
            catmetadata = xml.etree.ElementTree.parse(OVERLAY_METADATA)
            return catmetadata.find('longdescription[@lang="en"]').text.strip()

        DEFAULT_METADATA = os.path.join(PORTTREE.getRepositoryPath(self.DEFAULT), '%s/metadata.xml' % category)
        if os.path.exists(DEFAULT_METADATA):
            catmetadata = xml.etree.ElementTree.parse(DEFAULT_METADATA)
            return catmetadata.find('longdescription[@lang="en"]').text.strip()

        raise FileNotFoundError("%s's %s/metadata.xml does not exist" % (self.repository, category))


class Category(Repository):
    def __init__(self, repository, category):
        super().__init__(repository)

        if category not in self.categories():
            raise Exception("Invalid category %s/%s" % (repository, category))

        self.category = category

    def packages(self):
        all_packages = PORTTREE.cp_all(categories=[self.category], trees=[PORTTREE.getRepositoryPath(self.repository)])
        packages = set()
        for package in all_packages:
            _, name = package.split('/')
            packages.add(name)

        return sorted(packages, key=str.lower)

    # Semantically, I'd rather this be in class Package, but we need it for package_description
    # Returns package versions in lowest to highest
    def _package_versions(self, package):
        return PORTTREE.cp_list('%s/%s' % (self.category, package), mytree=PORTTREE.getRepositoryPath(self.repository))

    # Semantically, I'd rather this be in class Package, but we need it for package_description
    def _package_newest_version(self, package):
        return portage.best(self._package_versions(package))

    def package_description(self, package):
        return PORTTREE.aux_get(self._package_newest_version(package), ['DESCRIPTION'], myrepo=self.repository)[0]


class Package(Category):
    def __init__(self, repository, category, package):
        super().__init__(repository, category)

        if package not in self.packages():
            raise Exception("Invalid package %s/%s/%s" % (repository, category, package))

        self.package = package

    # Returns package versions, highest to lowest
    def versions(self):
        return map(self._extract_version, reversed(self._package_versions(self.package)))

    @staticmethod
    def _extract_version(package_version):
        # This does not seem to be in the stable portage lib yet
        # return portage.cpv_getversion(package_version)

        cp = portage.cpv_getkey(package_version)
        return package_version[len(cp) + 1:]

    def package_newest_version(self):
        return self._extract_version(portage.best(self._package_versions(self.package)))

    def package_description(self):
        return super().package_description(self.package)
