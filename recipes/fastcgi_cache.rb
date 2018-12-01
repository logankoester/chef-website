if node['nginx']['fastcgi_cache']
  template "/etc/nginx/sites/fastcgi_cache.conf" do
    action :create
    mode '0644'
    source 'nginx/fastcgi_cache.conf.erb'
    variables(
      nginx: node['nginx'],
    )
    notifies :reload, 'service[nginx]' unless node['nginx']['supervisor']
  end
end
