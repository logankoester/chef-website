include_recipe 'pacman'

if node['nginx']['fastcgi_cache']

  package('nginx-mod-cache_purge') { action :install }
  node.run_state['nginx_configure_flags'] =
    node.run_state['nginx_configure_flags'] | ['--with-ngx_cache_purge']

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
