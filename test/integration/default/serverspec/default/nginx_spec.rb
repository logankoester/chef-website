require 'spec_helper'

describe package('nginx') do
  it { should be_installed }
end

describe service('nginx') do
  it { should be_running }
end

describe file('/etc/nginx/sites') do
  it { should be_directory }
end

describe file('/etc/nginx/nginx.conf') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  its(:content) { should match /include sites\/\*.conf;/ }
end

describe file('/etc/nginx/sites/default.example.conf') do
  it { should be_file }
  its(:content) { should match /server_name default\.example www\.default\.example;/ }
  its(:content) { should match /listen 80;/ }
  its(:content) { should match /root \/sites\/default\.example\/www;/ }
end
