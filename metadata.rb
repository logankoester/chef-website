name             'website'
maintainer       'Logan Koester'
maintainer_email 'logan@logankoester.com'
license          'MIT'
description      'Install and configure sites for a webserver'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
supports 'arch'

depends 'nginx'
depends 'ssl_certificate'
depends 'pacman'
depends 'openssl'
depends 'deploy_key'
