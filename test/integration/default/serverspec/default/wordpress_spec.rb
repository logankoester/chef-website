require 'spec_helper'

describe package('wp-cli') do
  it { should be_installed }
end

describe file('/sites/default/www') do
  it { should be_directory }
end

describe file('/sites/default/www/wp-config.php') do
  it { should be_file }
  its(:content) { should match /@package WordPress/ }
end
