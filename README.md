# website cookbook
> A [Chef](http://getchef.com/) cookbook to install and configure sites for a webserver.

[![Build Status](http://ci.ldk.io/logankoester/chef-website/badge)](http://ci.ldk.io/logankoester/chef-website/)
[![Gittip](http://img.shields.io/gittip/logankoester.png)](https://www.gittip.com/logankoester/)

This cookbook is used for cloning websites to a server from Github repos. Static HTML sites, PHP sites, and Wordpress sites are all supported - pull requests to add support for additional types of website will be considered and appreciated.

## Installation

Using [Berkshelf](http://berkshelf.com/), add the `website` cookbook to your Berksfile.

```ruby
cookbook 'website', github: 'logankoester/chef-website', branch: 'master'
```
Then run `berks` to install it.

## Usage

Add the `website::default` recipe to your run list, and configure your site attributes (see below).

Sites are added by populating the `sites` attribute on your webserver node, like this:

```json
"sites": {
  "simple.example":  {
    "owner": "some_user",
    "root": "/sites/simple.example"
  }
}
```

In this trivial example, the `nginx` package will be installed and configured to serve traffic on port **80** for `http://simple.example` from the `/sites/simple.example` directory (which will be created if it does not exist).

See the [logankoester/chef-nginx](github.com/logankoester/chef-nginx) cookbook for details.

### PHP support

If any sites on a node have the optional `language` attribute set to `php`, then `php-fpm` will be installed and configured for that site.

```json
{ 
  "language": "php"
}
```

See the [logankoester/chef-nginx](github.com/logankoester/chef-nginx) cookbook for details.

### SSL certificates

If a site has the optional `ssl` attribute, then an SSL certificate will be created and `nginx` will be configured to listen on port **443** in addition to port **80**.

```json
{ 
  "ssl": {
    "common_name": "simple.example"
  }
}
```

You can create a self-signed certificate (default), or read a custom one from attributes, data bags or chef-vaults.

See the [ssl_certificate](https://supermarket.getchef.com/cookbooks/ssl_certificate) cookbook for details.

## Author

Copyright (c) 2014 [Logan Koester](http://logankoester.com). Released under the MIT license. See `LICENSE` for details.
