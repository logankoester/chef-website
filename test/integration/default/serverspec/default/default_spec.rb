require 'spec_helper'

describe file('/sites/default.example') do
  it { should be_directory }
  it { should be_owned_by 'default' }
  it { should be_grouped_into 'http' }
end

describe file('/etc/nginx/sites/default.example.conf') do
  it { should be_file }
  its(:content) {
    should match /listen 80;/
    should match /listen 443;/
    should match /ssl on;/
    should match /server_name default\.example www\.default\.example;/
  }
end
