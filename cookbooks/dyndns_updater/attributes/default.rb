default[:dyndns][:zone] = 'example.com'
default[:dyndns][:user] = 'dyndns'
default[:dyndns][:public_key] = nil
default[:dyndns][:private_key] = nil
default[:dyndns][:install_path] = "/home/#{default[:dyndns][:user]}"
default[:dyndns][:record_type] = "A"
default[:dyndns][:ttl] = 100
default[:dyndns][:subdomain] = "home"
