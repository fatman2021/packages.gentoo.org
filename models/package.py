import portage
import os
import xml.etree.ElementTree
from urllib.parse import urlparse

PORTTREE = portage.db[portage.root]["porttree"].dbapi


class VersionMaskedException(Exception):
    pass


# As far as I'm aware these are not formally defined anywhere, so we're making up the sets as we go
def arch_list():
    name = "Default"

    DEFAULT = ["alpha", "amd64", "arm", "hppa", "ia64", "ppc", "ppc64", "sparc", "x86"]

    if name == "FreeBSD":
        return frozenset([arch for arch in self.valid_arches() if arch.endswith('-fbsd')])

    if name == "Prefix":
        # This will fail if we ever include more
        return frozenset([arch for arch in self.valid_arches() if "-" in arch and not arch.endswith('-fbsd')])

    if name == "Exotic":
        return frozenset([arch for arch in self.valid_arches() if "-" not in arch]) - DEFAULT

    return DEFAULT


def valid_arches():
    return frozenset(PORTTREE.settings["PORTAGE_ARCHLIST"])


# Returns package versions, highest to lowest
def keywords(Package, version):
    return PORTTREE.aux_get(
        "%s/%s-%s" % (Package.category, Package.package, version),
        ['KEYWORDS'],
        myrepo=Package.repository
    )[0].split()


def stability(Package, version):
    output = []
    all_keywords = keywords(Package, version)
    for keyword in arch_list():
        if keyword in all_keywords:
            output.append("+")
        elif "~" + keyword in all_keywords:
            output.append("~")
        elif "-" + keyword in all_keywords:
            output.append("-")
        else:
            output.append(None)

    return output


def mask(Package, version):
    return portage.getmaskingstatus(
        "%s/%s-%s" % (Package.category, Package.package, version),
    )


def masking_reason(Package, version):
    return portage.getmaskingreason(
        "%s/%s-%s" % (Package.category, Package.package, version),
        metadata=self._env,
        return_location=True,
        myrepo=Package.repository
    )


# trying to emulate the current packages.gento.org behavior
def recent_changes(Package):
    output = []
    with open(os.path.join(PORTTREE.getRepositoryPath(Package.repository), '%s/%s/ChangeLog' % (Package.category, Package.package)), 'r') as fh:
        for line in fh:
            line = line.strip()

            if not line:
                if output:
                    break
                continue

            if line[0] == '#':
                continue

            if line[0] == '*':
                continue

            output.append(line)

    return output


def homepage(Package):
    pages = PORTTREE.aux_get(Package._package_newest_version(Package.package), ['HOMEPAGE'], myrepo=Package.repository)[0].split()

    out = {}
    for url in pages:
        out[urlparse(url).netloc] = url

    return out
