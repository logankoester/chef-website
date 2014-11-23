require 'spec_helper'

[
  file('/sites/default/ssl'),
  file('/sites/default/ssl/keys'),
  file('/sites/default/ssl/certs')
].each do |path|
  describe path do
    it { should be_directory }
    it { should be_owned_by 'default' }
    it { should be_grouped_into 'http' }
  end
end

[
  file('/sites/default/ssl/keys/default.key'),
  file('/sites/default/ssl/certs/default.pem')
].each do |path|
  describe path do
    it { should be_file }
  end
end

describe file('/etc/nginx/sites/default.conf') do
  its(:content) { should match /listen 443;/ }
  its(:content) { should match /ssl on;/ }
  its(:content) { should match /ssl_certificate .*default\.pem;/ }
  its(:content) { should match /ssl_certificate_key .*default\.key;/ }
end
