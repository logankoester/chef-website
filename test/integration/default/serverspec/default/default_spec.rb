require 'spec_helper'

[
  file('/sites/default.example'),
  file('/sites/default.example/ssl'),
  file('/sites/default.example/ssl/keys'),
  file('/sites/default.example/ssl/certs')
].each do |path|
  describe path do
    it { should be_directory }
    it { should be_owned_by 'default' }
    it { should be_grouped_into 'http' }
  end
end

[
  file('/sites/default.example/ssl/keys/default.example.key'),
  file('/sites/default.example/ssl/certs/default.example.pem')
].each do |path|
  describe path do
    it { should be_file }
  end
end