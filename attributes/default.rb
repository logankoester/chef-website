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

# Generate a LetsEncrypt certificate?
default['site_defaults']['letsencrypt'] = false

# Any extra system packages this site might need
default['site_defaults']['packages']['install'] = []

# Any system packages this site should remove
default['site_defaults']['packages']['remove'] = []

# Any AUR packages this site should build and install
default['site_defaults']['packages']['aur'] = []

# Skip the 'user' recipe for this site.
default['site_defaults']['skip_user'] = false

# Enable nginx fastcgi cache for this site
default['site_defaults']['fastcgi_cache'] = true
default['site_defaults']['fastcgi_cache_zone'] = 'WEBSITE'
default['site_defaults']['fastcgi_cache_valid'] = '60m'

# Enable nginx fastcgi cache
default['nginx']['fastcgi_cache'] = true

# Cache storage path
default['nginx']['fastcgi_cache_path'] = '/var/cache/nginx'

# Hierarchy levels of a cache
default['nginx']['fastcgi_cache_levels'] = '1:2'

# All active keys and information about data are stored in a shared memory zone,
# whose name and size are configured by the keys_zone parameter. One megabyte 
# zone can store about 8 thousand keys.
default['nginx']['fastcgi_keys_zone'] = 'WEBSITE:10m'

# Cached data that are not accessed during the time specified by the inactive parameter get removed from the cache regardless of their freshness
default['nginx']['fastcgi_cache_inactive'] = '60m'

default['nginx']['fastcgi_cache_key'] = '$scheme$request_method$host$request_uri'
default['nginx']['fastcgi_hide_header'] = 'Set-Cookie'
default['nginx']['fastcgi_ignore_headers'] = 'Cache-Control Expires Set-Cookie'
