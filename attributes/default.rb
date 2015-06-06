default['sites'] = []

# Override these defaults to suit your preferences.
#
# These default attributes will be applied to all `sites` members
# on which you have not set a value for the property explicitely.

# System user with ownership of the site files
default['site_defaults']['owner'] = 'http'

# Relative path from site.root where files should be served
default['site_defaults']['web_root'] = 'www'

# Set an optional proxy_pass string to create a reverse
# proxy instead, omitting the web_root
# eg: proxy_pass http://localhost:8000;
default['site_defaults']['proxy_pass'] = false

# Enable to redirect insecure http traffic to https
default['site_defaults']['redirect_insecure'] = false

# Does this site need PHP?
default['site_defaults']['php'] = false

# Is this a Wordpress site?
default['site_defaults']['wordpress'] = false

# Any extra system packages this site might need
default['site_defaults']['packages']['install'] = []

# Any system packages this site should remove
default['site_defaults']['packages']['remove'] = []

# Any AUR packages this site should build and install
default['site_defaults']['packages']['aur'] = []
