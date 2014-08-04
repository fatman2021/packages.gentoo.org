import bottle


def xhtml_esacpe(string):
    return string.replace('&', '&amp;') \
        .replace('<', '&#60;') \
        .replace('>', '&#62;') \
        .replace('"', '&#34;') \
        .replace("'", '&#039;')


def XHTML(callback):
    def wrapper(*args, **kwargs):
        bottle.response.content_type = "application/xhtml+xml; charset=utf-8"
        return callback(*args, **kwargs)

    return wrapper


bottle.install(XHTML)
bottle.SimpleTemplate.settings['escape_func'] = xhtml_esacpe
