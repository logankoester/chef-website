include_recipe 'nginx::default'

node['sites'].each do |name, site|
  raise "Attribute is missing a required property: sites.#{name}.owner" unless site['owner']
  raise "Attribute is missing a required property: sites.#{name}.root" unless site['root']

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
end
