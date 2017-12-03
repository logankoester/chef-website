require 'spec_helper'

describe user('default') do
  it { should exist }
  it { should belong_to_group 'default' }
  it { should belong_to_group 'http' }
  it { should have_home_directory '/home/default' }
end

[
  file('/home/default'),
  file('/home/default/.ssh'),
].each do |path|
  describe path do
    it { should be_directory }
    it { should be_owned_by 'default' }
    it { should be_grouped_into 'default' }
  end
end

describe file('/home/default/.ssh/config') do
  it { should be_file }
  it { should be_owned_by 'default' }
  it { should be_grouped_into 'default' }
  it { should contain 'Host git.example' }
  it { should contain 'User git' }
  it { should contain 'Hostname git.example' }
end

describe file('/home/default/.ssh/deploy_wrapper.sh') do
  it { should be_file }
  it { should be_owned_by 'default' }
  it { should be_grouped_into 'default' }
  it { should be_executable }
end
