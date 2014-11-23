include_recipe 'pacman'
pacman_aur('wp-cli'){ action [:build, :install] }

sites = data_bag 'sites'
sites.each do |site_id|
  next unless node['sites'].include? site_id
  site = data_bag_item 'sites', site_id

  wordpress = site['wordpress']
  if wordpress
    ::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

    wordpress['version'] = 'latest' unless wordpress.has_key? 'version'
    wordpress['url'] = "https://wordpress.org/wordpress-#{wordpress['version']}.tar.gz" unless wordpress.has_key? 'url'
    wordpress['languages'] = {} unless wordpress.has_key? 'languages'
    wordpress['languages']['lang'] = '' unless wordpress['languages'].has_key? 'lang'
    wordpress['allow_multisite'] = false unless wordpress.has_key? 'allow_multisite'

    wordpress['keys'] = {} unless wordpress.has_key? 'keys'
    wordpress['keys']['auth'] = secure_password unless wordpress['keys'].has_key? 'auth'
    wordpress['keys']['secure_auth'] = secure_password unless wordpress['keys'].has_key? 'secure_auth'
    wordpress['keys']['logged_in'] = secure_password unless wordpress['keys'].has_key? 'logged_in'
    wordpress['keys']['nonce'] = secure_password unless wordpress['keys'].has_key? 'nonce'

    wordpress['salt'] = {} unless wordpress.has_key? 'salt'
    wordpress['salt']['auth'] = secure_password unless wordpress['salt'].has_key? 'auth'
    wordpress['salt']['secure_auth'] = secure_password unless wordpress['salt'].has_key? 'secure_auth'
    wordpress['salt']['logged_in'] = secure_password unless wordpress['salt'].has_key? 'logged_in'
    wordpress['salt']['nonce'] = secure_password unless wordpress['salt'].has_key? 'nonce'

    site['wordpress'] = wordpress
    site.save unless Chef::Config[:solo]

    template File.join(site['root'], site['web_root'], 'wp-config.php') do
      source 'wordpress/wp-config.php.erb'
      owner site['owner']
      group 'http'
      mode '0644'
      variables(
        :db_name          => wordpress['db']['name'],
        :db_user          => wordpress['db']['user'],
        :db_password      => wordpress['db']['pass'],
        :db_host          => wordpress['db']['host'],
        :db_prefix        => wordpress['db']['prefix'],
        :auth_key         => wordpress['keys']['auth'],
        :secure_auth_key  => wordpress['keys']['secure_auth'],
        :logged_in_key    => wordpress['keys']['logged_in'],
        :nonce_key        => wordpress['keys']['nonce'],
        :auth_salt        => wordpress['salt']['auth'],
        :secure_auth_salt => wordpress['salt']['secure_auth'],
        :logged_in_salt   => wordpress['salt']['logged_in'],
        :nonce_salt       => wordpress['salt']['nonce'],
        :lang             => wordpress['languages']['lang'],
        :allow_multisite  => wordpress['allow_multisite'],
        :wp_siteurl       => wordpress['wp_siteurl'],
        :wp_home          => wordpress['wp_home']
      )
      action :create
    end
  end
end
