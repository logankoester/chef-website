node['sites'].each do |name, site|
  node['site_defaults'].each do |key, default_value|
    node.set_unless['sites'][name][key] = default_value
  end

  node.set_unless['sites'][name]['root'] = "/sites/#{name}"
  node.set_unless['sites'][name]['server_names'] = [name]
end
node.save unless Chef::Config[:solo]

include_recipe 'website::user'
include_recipe 'nginx::default'

node['sites'].each do |name, site|

  if site['git']
    git site['root'] do
      repository site['git']['repository']
      checkout_branch site['git']['branch']
      enable_submodules true
      user site['owner']
      group 'http'
      ssh_wrapper File.join('/home', site['owner'], '.ssh', 'deploy_wrapper.sh')
      action :sync
    end
  end

  [
    site['root'],
    File.join(site['root'], site['web_root'])
  ].each do |new_path|
    directory new_path do
      owner site['owner']
      group 'http'
      mode '0771'
      action :create
      recursive true
    end
  end

  include_recipe 'nginx::php_fpm' if site['php']
  include_recipe 'website::ssl' if site['ssl']
  include_recipe 'website::wordpress' if site['wordpress']

  template "/etc/nginx/sites/#{name}.conf" do
    mode '0644'
    source 'nginx/site.conf.erb'
    variables(
      name: name,
      site: site
    )
    notifies :reload, 'service[nginx]' unless node['nginx']['supervisor']
  end
end
