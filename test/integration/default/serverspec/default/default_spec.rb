require 'spec_helper'

describe file('/srv/http/default') do
  it { should be_directory }
  it { should be_owned_by 'default' }
  it { should be_grouped_into 'http' }
end

# Installing packages
describe package('sl') do
  it { should be_installed }
end

# Building packages from AUR
describe package('aurvote') do
  it { should be_installed }
end

# Removing packages
describe package('usbutils') do
  it { should_not be_installed }
end
