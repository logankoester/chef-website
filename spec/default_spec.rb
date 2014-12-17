require 'spec_helper'

describe 'website::default' do
  before do
    Fauxhai.mock(path: 'spec/fixtures/arch.json') do |node|
    end
    stub_data_bag('users').and_return(['site_admin', 'another_user'])
    stub_data_bag_item_from_file 'users', 'site_admin'
    stub_data_bag_item_from_file 'users', 'another_user'

    stub_data_bag('sites').and_return(['php_site', 'ssl_site', 'wordpress_site'])
    stub_data_bag_item_from_file 'sites', 'php_site'
    stub_data_bag_item_from_file 'sites', 'ssl_site'
    stub_data_bag_item_from_file 'sites', 'wordpress_site'
  end

  context 'with no sites' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        set_attributes_for node
        node.set['sites'] = []
      end.converge(described_recipe)
    end

    it 'should include the nginx::default recipe' do
      expect(chef_run).to include_recipe 'nginx::default'
    end

    it 'should not include the nginx::php_fpm recipe' do
      expect(chef_run).not_to include_recipe 'nginx::php_fpm'
    end
  end

  context 'with a PHP site' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        set_attributes_for node
        node.set['sites'] = ['php_site']
      end.converge(described_recipe)
    end

    it 'should create the site owner' do
      expect(chef_run).to create_user 'php_site_owner'
      expect(chef_run).to create_group 'http'
    end

    it 'should include the nginx::php_fpm recipe' do
      expect(chef_run).to include_recipe 'nginx::php_fpm'
    end

    it 'should not include the website::ssl recipe' do
      expect(chef_run).not_to include_recipe 'website::ssl'
    end

    it 'should create the site root' do
      expect(chef_run).to create_directory('/srv/http/php_site').with(
        user: 'php_site_owner',
        group: 'http'
      )
    end

    it 'should render the nginx/site.conf.erb template' do
      expect(chef_run).to render_file('/etc/nginx/sites/php_site.conf').with_content /listen 80;/
    end
  end

  context 'with an SSL site' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        set_attributes_for node
        node.set['sites'] = ['ssl_site']
      end.converge(described_recipe)
    end

    it 'should include the website::ssl recipe' do
      expect(chef_run).to include_recipe 'website::ssl'
    end

    it 'should create the ssl directories' do
      expect(chef_run).to create_directory '/srv/http/ssl_site/ssl/keys'
      expect(chef_run).to create_directory '/srv/http/ssl_site/ssl/certs'
    end

    it 'should render the nginx/site.conf.erb template with SSL configured' do
      expect(chef_run).to render_file('/etc/nginx/sites/ssl_site.conf').with_content(/listen 443;/)
    end

  end

  context 'with a Wordpress site' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        set_attributes_for node
        node.set['sites'] = ['wordpress_site']
      end.converge(described_recipe)
    end

    it 'should include the website::wordpress recipe' do
      expect(chef_run).to include_recipe 'website::wordpress'
    end

    it 'should render the wordpress/wp-config.php.erb template' do
      expect(chef_run).to render_file('/srv/http/wordpress_site/www/wp-config.php')
    end
  end

end
