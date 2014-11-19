require 'chefspec'
require 'chefspec/berkshelf'
require 'chefspec/cacher'

ChefSpec::Coverage.start!

RSpec.configure do |config|
end

def set_attributes_for(node)
  node.set['nginx']['supervisor'] = false
end

def stub_data_bag_item_from_file(data_bag, item)
  stub_data_bag_item(data_bag, item) {
    JSON.parse(
      File.read("spec/data_bags/#{data_bag}/#{item}.json")
    )
  }
end
