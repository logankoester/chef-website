sites = data_bag 'sites'
sites.each do |site_id|
  next unless node['sites'].include? site_id
  site = data_bag_item 'sites', site_id
  next if site['skip_user']

  username = site['owner']

  user username do
    home File.join('/home', username)
    manage_home true
  end

  group 'http' do
    append true
    members username
  end

  directory File.join('/home', username) do
    owner username
    group username
    mode  '0755'
    action :create
  end

  directory File.join('/home', username, '.ssh') do
    owner username
    group username
    mode  '0700'
    action :create
  end

  if site['deploy_key'] && site['deploy_key']['credentials'] && site['deploy_key']['repo']
    deploy_key "#{site_id}_deploy_key" do
      label "#{username}_deploy_key"

      if site['deploy_key']['provider'] == 'gitlab'
        provider Chef::Provider::DeployKeyGitlab
        api_url 'https://' + site['deploy_key']['provider_host']
      else
        provider Chef::Provider::DeployKeyGithub
      end

      path "/home/#{username}/.ssh"
      credentials({ :token => site['deploy_key']['credentials']['token'] })
      repo site['deploy_key']['repo']
      owner username
      group username
      mode '0700'
      action [:create, :add]
    end
  end

  template File.join('/home', username, '.ssh', "deploy_wrapper.sh") do
    action :create_if_missing
    source 'deploy_wrapper.sh.erb'
    variables(username: username)
    owner username
    group username
    mode '0700'
  end

  template File.join('/home', username, '.ssh', 'config') do
    action :create_if_missing
    source 'ssh_config.erb'

    if site['deploy_key']['provider'] == 'gitlab'
      ssh_config_host = site['deploy_key']['provider_host']
    else
      ssh_config_host = 'github.com'
    end

    variables(
      host: ssh_config_host,
      username: username
    )
    owner username
    group username
    mode '0644'
  end

  template File.join('/home', username, '.gitconfig') do
    action :create_if_missing
    source 'gitconfig.erb'
    variables(
      username: username,
      fqdn: node['fqdn']
    )
    owner username
    group username
    mode '0644'
  end

end
