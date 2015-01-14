data_bag('sites').each do |site_id|
  next unless node['sites'].include? site_id
  site = data_bag_item 'sites', site_id

  site['owner'] = node['site_defaults']['owner'] unless site.has_key? 'owner'
  site['web_root'] = node['site_defaults']['web_root'] unless site.has_key? 'web_root'
  site['php'] = node['site_defaults']['php'] unless site.has_key? 'php'
  site['wordpress'] = node['site_defaults']['wordpress'] unless site.has_key? 'wordpress'
  site.save unless Chef::Config[:solo]
end

include_recipe 'website::user'
include_recipe 'nginx::default'

php_site_detected = false
ssl_site_detected = false
wordpress_site_detected = false

data_bag('sites').each do |site_id|
  next unless node['sites'].include? site_id
  site = data_bag_item 'sites', site_id

  directory File.absolute_path(File.join(site['root'], '..')) do
    group 'http'
    mode '0775'
    action :create
  end

  if site['git']
    git "git_sync_#{site_id}" do
      destination site['root']
      repository site['git']['repository']
      revision site['git']['branch']
      enable_submodules true
      user site['owner']
      group 'http'
      ssh_wrapper File.join('/home', site['owner'], '.ssh', 'deploy_wrapper.sh')
      action :sync
    end
  end

  directory site['root'] do
    owner site['owner']
    group 'http'
    mode '0771'
    action :create
    recursive true
  end

  directory File.join(site['root'], site['web_root']) do
    owner site['owner']
    group 'http'
    mode '0771'
    action :create
    recursive true
  end

  template "/etc/nginx/sites/#{site_id}.conf" do
    mode '0644'
    source 'nginx/site.conf.erb'
    variables(
      site_id: site_id,
      site: site
    )
    notifies :reload, 'service[nginx]' unless node['nginx']['supervisor']
  end

  php_site_detected = true if site['php']
  ssl_site_detected = true if site['ssl']
  wordpress_site_detected = true if site['wordpress']
end

include_recipe 'nginx::php_fpm' if php_site_detected
include_recipe 'website::ssl' if ssl_site_detected
include_recipe 'website::wordpress' if wordpress_site_detected
