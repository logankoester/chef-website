include_recipe 'acme'

# Real certificates please...
node.set['acme']['endpoint'] = 'https://acme-v01.api.letsencrypt.org'

data_bag('sites').each do |site_id|
  next unless node['sites'].include? site_id
  site = data_bag_item 'sites', site_id
  if config = site['letsencrypt']

    # Set up contact information. Note the mailto: notation
    node.set['acme']['contact'] = [ "mailto:#{config['email']}" ]

    # Get and auto-renew the certificate from Let's Encrypt
    acme_certificate config['domain'] do
      fullchain "/srv/http/#{config['domain']}/ssl/certs/#{config['domain']}.pem.chained.pem"
      key      "/srv/http/#{config['domain']}/ssl/keys/#{config['domain']}.key"
      chain    "/srv/http/#{config['domain']}/ssl/certs/#{config['domain']}.crt"
      method   'http'
      wwwroot  "/srv/http/#{config['domain']}/#{site['web_root']}"
      notifies :restart, 'service[nginx]'
      alt_names config['alt_domains']
    end
  end
end
