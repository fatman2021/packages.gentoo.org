import bottle


class CSPPlugin(object):
    name = 'csp'
    api = 2

    def setup(self, app):
        self.rules = {}

        for key in app.config:
            if key.startswith("CSP."):
                rule = key[4:]
                self.rules[rule] = app.config[key]

    def apply(self, callback, route):
        def wrapper(*args, **kwargs):
            if self.rules:
                bottle.response.set_header("Content-Security-Policy", "; ".join(
                    '{0} {1}'.format(key, val) for key, val in self.rules.items()
                ))

            return callback(*args, **kwargs)

        return wrapper

Plugin = CSPPlugin
