require 'spec_helper'

describe package('nginx') do
  it { should be_installed }
end

describe service('nginx') do
  it { should be_running }
end

describe package('php-fpm') do
  it { should be_installed }
end

describe service('php-fpm') do
  it { should be_running }
end
