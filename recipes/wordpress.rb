include_recipe 'pacman'
pacman_aur('wp-cli'){ action [:build, :install] }

node['sites'].each do |name, site|
  if site['wordpress']
    ::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
    node.default_unless['sites'][name]['wordpress']['version'] = 'latest'
    node.default_unless['sites'][name]['wordpress']['url'] = "https://wordpress.org/wordpress-#{node['sites'][name]['wordpress']['version']}.tar.gz"
    node.default_unless['sites'][name]['wordpress']['languages']['lang'] = ''
    node.default_unless['sites'][name]['wordpress']['allow_multisite'] = false

    node.set_unless['sites'][name]['wordpress']['keys']['auth'] = secure_password
    node.set_unless['sites'][name]['wordpress']['keys']['secure_auth'] = secure_password
    node.set_unless['sites'][name]['wordpress']['keys']['logged_in'] = secure_password
    node.set_unless['sites'][name]['wordpress']['keys']['nonce'] = secure_password
    node.set_unless['sites'][name]['wordpress']['salt']['auth'] = secure_password
    node.set_unless['sites'][name]['wordpress']['salt']['secure_auth'] = secure_password
    node.set_unless['sites'][name]['wordpress']['salt']['logged_in'] = secure_password
    node.set_unless['sites'][name]['wordpress']['salt']['nonce'] = secure_password
    node.save unless Chef::Config[:solo]

    template File.join(node['sites'][name]['root'], node['sites'][name]['web_root'], 'wp-config.php') do
      source 'wordpress/wp-config.php.erb'
      owner node['sites'][name]['owner']
      group 'http'
      mode '0644'
      variables(
        :db_name          => node['sites'][name]['wordpress']['db']['name'],
        :db_user          => node['sites'][name]['wordpress']['db']['user'],
        :db_password      => node['sites'][name]['wordpress']['db']['pass'],
        :db_host          => node['sites'][name]['wordpress']['db']['host'],
        :db_prefix        => node['sites'][name]['wordpress']['db']['prefix'],
        :auth_key         => node['sites'][name]['wordpress']['keys']['auth'],
        :secure_auth_key  => node['sites'][name]['wordpress']['keys']['secure_auth'],
        :logged_in_key    => node['sites'][name]['wordpress']['keys']['logged_in'],
        :nonce_key        => node['sites'][name]['wordpress']['keys']['nonce'],
        :auth_salt        => node['sites'][name]['wordpress']['salt']['auth'],
        :secure_auth_salt => node['sites'][name]['wordpress']['salt']['secure_auth'],
        :logged_in_salt   => node['sites'][name]['wordpress']['salt']['logged_in'],
        :nonce_salt       => node['sites'][name]['wordpress']['salt']['nonce'],
        :lang             => node['sites'][name]['wordpress']['languages']['lang'],
        :allow_multisite  => node['sites'][name]['wordpress']['allow_multisite'],
        :wp_siteurl       => node['sites'][name]['wordpress']['wp_siteurl'],
        :wp_home          => node['sites'][name]['wordpress']['wp_home']
      )
      action :create
    end
  end
end
