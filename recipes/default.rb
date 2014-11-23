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

data_bag('sites').each do |site_id|
  next unless node['sites'].include? site_id
  site = data_bag_item 'sites', site_id

  if site['git']
    git "git_sync_#{site_id}" do
      destination site['root']
      repository site['git']['repository']
      checkout_branch site['git']['branch']
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

  include_recipe 'nginx::php_fpm' if site['php']
  include_recipe 'website::ssl' if site['ssl']
  include_recipe 'website::wordpress' if site['wordpress']

  template "/etc/nginx/sites/#{site_id}.conf" do
    mode '0644'
    source 'nginx/site.conf.erb'
    variables(
      site_id: site_id,
      site: site
    )
    notifies :reload, 'service[nginx]' unless node['nginx']['supervisor']
  end
end
