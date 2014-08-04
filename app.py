#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import bottle
from plugins import csp, xhtml
from models.collections import Trees, Overlays, Repository, Category, Package
import models.package as pkg

bottle.debug(True)


@bottle.route("/")
@bottle.view("search")
def index():
    return dict(
        Overlays=Overlays,
    )


@bottle.route("/<repository>")
@bottle.view("list_of_categories")
def list_of_categories(repository):
    if repository not in Trees.repositories():
        raise bottle.HTTPError(404, "Not found")

    return dict(
        Overlays=Overlays,
        Repository=Repository(repository),
    )


@bottle.route("/<repository>/<category:re:[\w+][\w+.-]*>")
@bottle.view("list_of_packages")
def list_of_packages(repository, category):
    if repository not in Trees.repositories():
        bottle.abort(404, "Not found")

    if category not in Repository(repository).categories():
        bottle.abort(404, "Not found")

    return dict(
        Overlays=Overlays,
        Category=Category(repository, category),
    )


@bottle.route("/<repository>/<category:re:[\w+][\w+.-]*>/<package:re:[\w+][\w+.-]*>")
@bottle.view("list_of_versions")
def list_of_versions(repository, category, package):
    return dict(
        Overlays=Overlays,
        Package=Package(repository, category, package),
        pkg=pkg,
    )


@bottle.error(404)
@bottle.view("404")
def error404(error):
    return dict(
        Overlays=Overlays,
    )


# Legacy URL redirects


@bottle.route("/package/<category:re:[\w+][\w+.-]*>/<packagere:[\w+][\w+.-]*>")
def legacy_list_of_versions(category, package):
    bottle.redirect("/%s/%s/%s" % (Overlays.DEFAULT, category, parkage))


@bottle.route("/categories")
def legacy_list_of_categories():
    bottle.redirect("/%s" % Overlays.DEFAULT)


# TODO: determine why this redirect isn't working
@bottle.route("/category/<category:re:[\w+][\w+.-]*>")
def legacy_list_of_packages(category):
    bottle.redirect("/%s/%s" % (Overlays.DEFAULT, category))
