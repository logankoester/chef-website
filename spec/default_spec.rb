require 'spec_helper'

describe 'website::default' do
  before do
    Fauxhai.mock(path: 'spec/fixtures/arch.json') do |node|
    end
    stub_data_bag('users').and_return(['site_admin', 'another_user'])
    stub_data_bag_item_from_file 'users', 'site_admin'
    stub_data_bag_item_from_file 'users', 'another_user'
  end

  context 'with no sites' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        set_attributes_for node
        node.set['sites'] = {}
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
        node.set['sites'] = {
          php_site: {
            language: 'php'
          }
        }
      end.converge(described_recipe)
    end

    it 'should include the nginx::php_fpm recipe' do
      expect(chef_run).to include_recipe 'nginx::php_fpm'
    end

    it 'should not include the website::ssl recipe' do
      expect(chef_run).not_to include_recipe 'website::ssl'
    end
  end

  context 'with an SSL site' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        set_attributes_for node
        node.set['sites'] = {
          ssl_site: {
            ssl: true
          }
        }
      end.converge(described_recipe)
    end

    it 'should include the website::ssl recipe' do
      expect(chef_run).to include_recipe 'website::ssl'
    end
  end

end
