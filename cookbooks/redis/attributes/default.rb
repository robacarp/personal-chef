default[:redis][:auth_key] = '0000000000000000000000000000'
default[:redis][:version] = '3.0.2'
default[:redis][:basename] = "redis-#{node[:redis][:version]}"
default[:redis][:tar] = "#{node[:redis][:basename]}.tar.gz"
default[:redis][:url] = "http://download.redis.io/releases/#{node[:redis][:tar]}"
