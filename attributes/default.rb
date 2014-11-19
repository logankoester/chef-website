default['sites'] = {}

# Override these defaults to suit your preferences.
#
# These default attributes will be applied to all `sites` members
# on which you have not set a value for the property explicitely.

# System user with ownership of the site files
default['site_defaults']['owner'] = 'http'

# Relative path from site.root where files should be served
default['site_defaults']['web_root'] = 'www'
