import portage
import os
import re
import portage.xml.metadata
from xml.etree.ElementTree import ParseError
from urllib.parse import urlparse
from collections import namedtuple


# local_config=False tells this to ignore all changes in /etc/portage
SETTINGS = portage.config(local_config=False)

PORTTREE = portage.portagetree(settings=SETTINGS).dbapi


class VersionMaskedException(Exception):
    pass


# As far as I'm aware these are not formally defined anywhere, so we're making up the sets as we go
def arch_list():
    name = "Default"

    DEFAULT = ["alpha", "amd64", "arm", "hppa", "ia64", "ppc", "ppc64", "sparc", "x86"]

    if name == "FreeBSD":
        return frozenset([arch for arch in self.valid_arches() if arch.endswith('-fbsd')])

    if name == "Prefix":
        # Warning: This will fail if we ever include more archs with hyphens than fbsd
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
        settings=SETTINGS,
        portdb=PORTTREE,
        myrepo=Package.repository
    )


def masking_reason(Package, version):
    return portage.getmaskingreason(
        "%s/%s-%s" % (Package.category, Package.package, version),
        settings=SETTINGS,
        metadata=self._env,
        return_location=True,
        myrepo=Package.repository
    )


# trying to emulate the current packages.gento.org behavior
def recent_changes(Package):
    output = []

    CHANGELOG = os.path.join(PORTTREE.getRepositoryPath(Package.repository), '%s/%s/ChangeLog' % (Package.category, Package.package))

    if os.path.isfile(CHANGELOG):
        with open(CHANGELOG, 'r') as fh:
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


def _metadata(Package):
    METAFILE = os.path.join(PORTTREE.getRepositoryPath(Package.repository), '%s/%s/metadata.xml' % (Package.category, Package.package))
    HERDFILE = os.path.join(PORTTREE.getRepositoryPath(Package.repository), 'metadata/herds.xml')

    if not os.path.isfile(HERDFILE):
        HERDFILE = s.path.join(PORTTREE.getRepositoryPath(Package.DEFAULT), 'metadata/herds.xml')

    return portage.xml.metadata.MetaDataXML(METAFILE, HERDFILE)


def upstream(Package):
    try:
        upstream = _metadata(Package).upstream()
        if upstream:
            return upstream[0]
    except ParseError:
        return None


def stability_color(stability):
    if stability == "+":
        return 'alert-success'
    if stability == "~":
        return 'alert-warning'
    if stability == "-":
        return 'alert-danger'
    if stability is None:
        return ''


def stability_text(stability):
    if stability is None:
        return ''

    return stability


# Use tables

def _global_use_description():
    out = {}
    for line in portage.grabfile('/usr/portage/profiles/use.desc'):
        flag, desc = line.split(" - ", 1)
        out[flag] = desc

    return out


def _local_use_description(Package):
    out = {}
    try:
        for use_flag in _metadata(Package).use():
            out[use_flag.name] = use_flag.desc
    except ParseError:
        pass
    finally:
        return out


def _raw_iuse(Package):
    return frozenset(PORTTREE.aux_get(Package._package_newest_version(Package.package), ['IUSE'], myrepo=Package.repository)[0].split())


def use(Package):
    out = []

    global_use = _global_use_description()
    local_use = _local_use_description(Package)

    for use_flag in _raw_iuse(Package):
        if use_flag[0] == '+':
            use_flag = use_flag[1:]

        if (use_flag in global_use):
            out.append((use_flag, global_use[use_flag]))
            continue

        if (use_flag in local_use):
            out.append((use_flag, global_use[use_flag]))
            continue

        out.append((use_flag, None))
    return out


def default_use(Package):
    return frozenset([x[1:] for x in _raw_iuse(Package) if x[0] == '+'])
