include_recipe 'nginx::default'

node['sites'].each do |name, site|
  [
    File.join(site['root'], 'ssl'),
    File.join(site['root'], 'ssl', 'keys'),
    File.join(site['root'], 'ssl', 'certs')
  ].each do |new_path|
    directory new_path do
      owner site['owner']
      group 'http'
      mode '0600'
      action :create
      recursive true
      only_if { site['ssl'] }
    end
  end

  ssl_certificate name do
    namespace site
    key_path File.join(site['root'], 'ssl', 'keys', "#{name}.key")
    cert_path File.join(site['root'], 'ssl', 'certs', "#{name}.pem")
    notifies :restart, 'service[nginx]' unless node['nginx']['supervisor']
    only_if { site['ssl'] }
  end

  # TODO - Update nginx conf...
end
