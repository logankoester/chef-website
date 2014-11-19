include_recipe 'nginx::default'

node['sites'].each do |name, site|
  if site['language'] && site['language'].downcase == 'php'
    include_recipe 'nginx::php_fpm'
  end

  if site['ssl']
    include_recipe 'website::ssl'
  end
end
