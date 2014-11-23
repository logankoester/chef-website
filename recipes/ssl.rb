include_recipe 'nginx::default'

sites = data_bag 'sites'
sites.each do |site_id|
  next unless node['sites'].include? site_id
  site = data_bag_item 'sites', site_id

  if site['ssl']
    ['ssl', 'ssl/keys', 'ssl/certs'].each do |new_path|
      directory "#{site['root']}/#{new_path}" do
        owner site['owner']
        group 'http'
        mode '0600'
        action :create
        recursive true
      end
    end
  end

  if site['ssl']
    ssl_certificate site_id do
      namespace site
      key_path File.join(site['root'], 'ssl', 'keys', "#{site_id}.key")
      cert_path File.join(site['root'], 'ssl', 'certs', "#{site_id}.pem")
      notifies :restart, 'service[nginx]' unless node['nginx']['supervisor']
    end
  end
end
