require 'spec_helper'

describe 'website::ssl' do
  before do
    Fauxhai.mock(path: 'spec/fixtures/arch.json') do |node|
    end
    stub_data_bag('users').and_return(['site_admin', 'another_user'])
    stub_data_bag_item_from_file 'users', 'site_admin'
    stub_data_bag_item_from_file 'users', 'another_user'
  end

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      set_attributes_for node
      node.set['sites'] = {
        non_ssl_site: {
          owner: 'non_ssl_site_owner',
          root: '/sites/non_ssl_site'
          server_names: ['non_ssl_site.example'],
        },
        ssl_site: {
          owner: 'ssl_site_owner',
          root: '/sites/ssl_site',
          server_names: ['ssl_site.example'],
          ssl: {
            common_name: 'non_ssl_site.example'
          }
        },
      }
    end.converge(described_recipe)
  end

  it 'should create the ssl directories' do
    expect(chef_run).to create_directory '/sites/ssl_site/ssl/keys'
    expect(chef_run).to create_directory '/sites/ssl_site/ssl/certs'
  end

end
