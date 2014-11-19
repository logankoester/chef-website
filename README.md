# website cookbook
> A [Chef](http://getchef.com/) cookbook to install and configure sites for a webserver.

[![Build Status](http://ci.ldk.io/logankoester/chef-website/badge)](http://ci.ldk.io/logankoester/chef-website/)
[![Test Coverage](https://codeclimate.com/github/logankoester/chef-website/badges/coverage.svg)](https://codeclimate.com/github/logankoester/chef-website)
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
    "root": "/sites/simple.example"
  }
}
```

In this trivial example, the `nginx` package will be installed and configured to serve traffic on port **80** for `http://simple.example` from the `/sites/simple.example` directory (which will be created if it does not exist).

See the [logankoester/chef-nginx](github.com/logankoester/chef-nginx) cookbook for details.

### PHP support

If any sites on a node have a truthy `php` attribute, then `php-fpm` will be installed and configured for that site.

```json
{ 
  "php": true
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

### User accounts

If you specify an `owner`, that user will be created if missing and added to the `http` group. If no owner is specified, a default `http` user will be used. A home directory will
be created at `/home/#{owner}` and populated with these files:

* `.gitconfig`
* `.ssh/config`
* `.ssh/deploy_wrapper.sh`
* `.ssh/deploy_key` (see below)

If any of these files already exist, they will be left alone, so you can add sites to existing accounts
if you want to - but you may need to tweak yours if you want to deploy.

The `.ssh/deploy_key` file will be generated if you have set the `deploy_key.credentials` property on a site.

This key will be added to your account at the repository provider and subsequently used to deploy these sites.

See the [deploy_key](https://supermarket.getchef.com/cookbooks/deploy_key) cookbook for authorization details.

> Note that if you want to use different deploy keys for different sites you must separate them by putting those sites under a different owner (system account).

## Author

Copyright (c) 2014 [Logan Koester](http://logankoester.com). Released under the MIT license. See `LICENSE` for details.
