# website cookbook
> A [Chef](http://getchef.com/) cookbook to set up an [nginx](http://nginx.org) webserver and install sites from a data bag.

[![Build Status](http://ci.ldk.io/logankoester/chef-website/badge)](http://ci.ldk.io/logankoester/chef-website/)
[![Test Coverage](https://codeclimate.com/github/logankoester/chef-website/badges/coverage.svg)](https://codeclimate.com/github/logankoester/chef-website)
[![Gittip](http://img.shields.io/gittip/logankoester.png)](https://www.gittip.com/logankoester/)

## Overview

This cookbook can be used for static sites, PHP scripts, and WordPress installations. nginx will always be installed, but all other packages (like `php-fpm` for example) will only be installed if a node actually needs that part of the stack for the sites that it runs.

You can (and should!) also configure SSL certificates for your sites, although it is optional.

Assuming you want your site files to be installed by Chef (alternatively you could just drop the files in later), they should be on Github, with a tree something like

```
├── nginx
│   └── nginx.conf
├── ssl
│   ├── certs
│   └── keys
└── www
```

Your `site['web_root']` should be a subdirectory (`www` by default), because web projects generally have a few files (scripts, logs, configs, secrets, etc) that should be checked into the repo, but should not be served by nginx. I also recommend adding `ssl/` to your **.gitignore**, since it will be populated with files by Chef.

If you provide Github OAuth token with the `repo` scope, then a deploy key will be created for the `site['owner']` and added to your site repo automatically for each node. If your site repo is private, then a deploy key is required or Chef cannot sync it.

If you like, you can also add extra nginx configuration files to your repo at `nginx/*.conf`, and they will be loaded. This is not required.

## Installation

Using [Berkshelf](http://berkshelf.com/), add the `website` cookbook to your Berksfile.

```ruby
cookbook 'website', github: 'logankoester/chef-website', branch: 'master'
```
Then run `berks` to install it.

## Usage

In the simplest case (no sites), including the default recipe in the run list will do nothing more than install, enable and start the nginx with any configuration at `/etc/nginx/sites/*.conf`.

To start writing site definitions, create a data bag called `sites` and refer to the examples below.

Next, set the attribute `node['sites']` to an array of sites you want installed. Depending on your goals, you can have multiple sites on just node, one site running on several nodes, or any combination.

An item in the `sites` data bag should look something like this.


```json
"sites": {
  "simple.example":  {
    "root": "/srv/http/simple.example"
  }
}
```

In this barebones example, `nginx` will serve traffic on port **80** for `http://simple.example` from the `/sites/simple.example` directory (which will be created if it does not exist).

### PHP support

If any sites have a truthy `php` property, then `php-fpm` will be installed and configured.

```json
{ 
  "php": true
}
```

### Reverse proxy

If you want a reverse proxy, you can create a site with the `proxy_pass` string set instead of a web root.

```json
{ 
  "proxy_pass": "http://localhost:8000"
}
```

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

### Redirect insecure

If the optional `redirect_insecure` attribute is set to `true`, then the site will redirect all http traffic to https.


```json
{ 
  "redirect_insecure": true
}
```

### User accounts

If you specify an `owner`, that user will be created if missing and added to the `http` group. If no owner is specified, a default `http` user will be used. A home directory will be created at `/home/#{owner}`.

### Deploy keys

If you want Chef to deploy your site from a private repo, you must authorize it by setting the `deploy_key` object.

To obtain a token, you will need to register an application at `https://github.com/settings/applications` (or the equivilant page for your Github Organization), and then follow the [OAuth Web Application Flow](https://developer.github.com/v3/oauth/#web-application-flow) (easiest with an API testing tool like [Postman](http://www.getpostman.com/)).

```json
"deploy_key": {
  "credentials": {
    "token": "AUTHORIZED_GITHUB_OAUTH_TOKEN"
  },
  "repo": "username/site-repo"
}
```

If a site has a valid `deploy_key` object, a deploy key will be added to your site repo for each node that needs one, and the `site['owner']`'s home directory will be populated with these files:

* `.gitconfig`
* `.ssh/config`
* `.ssh/deploy_wrapper.sh`
* `.ssh/deploy_key`

If any of these files already exist, they will be left alone, so you can add sites to existing accounts if you want to - but you may need to tweak things if you want to deploy.

See the [deploy_key](https://supermarket.getchef.com/cookbooks/deploy_key) cookbook for authorization details.

> Note that if you want to use different deploy keys for different sites you must separate them by putting those sites under a different owner).

## Running the tests

This cookbook uses the [Foodcritic](http://www.foodcritic.io/) linter, [ChefSpec](http://sethvargo.github.io/chefspec/) for unit testing, and [ServerSpec](http://serverspec.org/) for integration testing via [Test Kitchen](http://kitchen.ci/) with the [kitchen-docker](https://github.com/portertech/kitchen-docker) driver.

It's not as complicated as it sounds, but you will need to have Docker installed.

1. `git clone git@github.com:logankoester/chef-website.git`
2. `cd chef-website`
3. `bundle install`
4. `bundle exec rake`

This will run all of the tests once. While developing, run `bundle exec guard start` and the relevant tests will run automatically when you save a file.

## Author

Copyright (c) 2014-2015 [Logan Koester](http://logankoester.com). Released under the MIT license. See `LICENSE` for details.
