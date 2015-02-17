require 'spec_helper'

ssl_dir = '/srv/http/default/ssl'
subject_command = "openssl x509 -noout -subject -in"
fingerprint_command = "openssl x509 -noout -fingerprint -in"
key_path = File.join(ssl_dir, 'keys', 'default.key')
cert_path = File.join(ssl_dir, 'certs', 'default.pem')

describe file('/etc/nginx/sites/default.conf') do
  its(:content) { should match /listen 443;/ }
  its(:content) { should match /ssl on;/ }
  its(:content) { should match /ssl_certificate .*default\.pem;/ }
  its(:content) { should match /ssl_certificate_key .*default\.key;/ }
end

[
  file(ssl_dir),
  file(File.join(ssl_dir, 'keys')),
  file(File.join(ssl_dir, 'certs'))
].each do |path|
  describe path do
    it { should be_directory }
    it { should be_owned_by 'default' }
    it { should be_grouped_into 'http' }
  end
end

[
  file(key_path),
  file(cert_path)
].each do |path|
  describe path do
    it { should be_file }
  end
end

describe command("#{subject_command} #{cert_path}") do
  its(:stdout) { should match /subject= \/CN=default\.example/ }
end

describe command("#{fingerprint_command} /srv/http/secondary/ssl/certs/secondary.pem") do
  its(:stdout) { should match /SHA1 Fingerprint=90:35:5E:38:92:8B:5C:4A:75:24:01:14:44:D6:A3:45:DB:00:34:C1/ }
end

describe command("#{fingerprint_command} /srv/http/secondary/ssl/certs/secondary.chained.pem") do
  its(:stdout) { should match /SHA1 Fingerprint=90:35:5E:38:92:8B:5C:4A:75:24:01:14:44:D6:A3:45:DB:00:34:C1/ }
end
