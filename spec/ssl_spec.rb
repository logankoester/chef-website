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
        non_ssl_site: {},
        ssl_site: {
          root: '/sites/ssl_site',
          ssl: {
            common_name: 'non_ssl_site.example'
          }
        },
      }
    end.converge(described_recipe)
  end

end
