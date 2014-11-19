node['sites'].each do |name, site|
  cert = ssl_certificate name do
    namespace site
    notifies :restart, 'service[nginx]' unless node['nginx']['supervisor']
    only_if { site['ssl'] }
  end

  # TODO - Update nginx conf...
end
