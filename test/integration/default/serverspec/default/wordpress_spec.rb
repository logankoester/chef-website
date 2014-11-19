require 'spec_helper'

describe file('/etc/nginx/sites/default.example.conf') do
  its(:content) { should match /Add trailing slash.*wp-admin requests/ }
  its(:content) { should match /WP Super Cache/ }
end
