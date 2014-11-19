include_recipe 'nginx::default'

node['sites'].each do |name, site|
  raise "Attribute is missing a required property: sites.#{name}.owner" unless site['owner']
  raise "Attribute is missing a required property: sites.#{name}.root" unless site['root']
  raise "Attribute is missing a required property: sites.#{name}.server_names" unless site['server_names']

  user site['owner']
  group 'http' do
    append true
    members site['owner']
  end

  directory site['root'] do
    owner site['owner']
    group 'http'
    mode '0771'
    action :create
    recursive true
  end

  if site['language'] && site['language'].downcase == 'php'
    include_recipe 'nginx::php_fpm'
  end

  if site['ssl']
    include_recipe 'website::ssl'
  end

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
