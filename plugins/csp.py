import bottle

CDN = "https://1b9a50f4f9de4348cd9f-e703bc50ba0aa66772a874f8c7698be7.ssl.cf5.rackcdn.com"


def CSP(callback):
    def wrapper(*args, **kwargs):
        bottle.response.set_header("Content-Security-Policy", "; ".join([
            "default-src 'none'",
            "style-src " + " ".join([CDN]),
            "script-src " + " ".join([CDN]),
            "font-src " + " ".join([CDN]),
            "img-src " + " ".join([CDN, "https://www.gentoo.org"]),
            "form-action 'none'",  # this will change to self, when we're ready to enable searching
            "frame-ancestors 'none'",  # this will change to self, when we're ready to enable searching
        ]))
        return callback(*args, **kwargs)

    return wrapper


bottle.install(CSP)
