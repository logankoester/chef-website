require 'spec_helper'

describe package('php-fpm') do
  it { should be_installed }
end

describe service('php-fpm') do
  it { should be_running }
end

describe file('/etc/nginx/sites/default.conf') do
  its(:content) { should match /fastcgi_pass.*php-fpm\.sock;/ }
  its(:content) { should match /fastcgi_index.*index\.php;/ }
end

describe file('/etc/php/php.ini') do
  its(:content) { should match /upload_max_filesize = 1024M/ }
  its(:content) { should match /phar.readonly = Off/ }
end
