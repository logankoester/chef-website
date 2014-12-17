require 'spec_helper'

describe file('/srv/http/default') do
  it { should be_directory }
  it { should be_owned_by 'default' }
  it { should be_grouped_into 'http' }
end
