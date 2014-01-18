default[:nsd][:version] = '4.0.0'
default[:nsd][:basename] = "nsd-#{node[:nsd][:version]}"
default[:nsd][:tar] = "#{node[:nsd][:basename]}.tar.gz"
default[:nsd][:url] = "http://www.nlnetlabs.nl/downloads/nsd/#{node[:nsd][:tar]}"
default[:nsd][:checksum] = "62608a409d0f68c9d8d4595031b9de9130ac02efe39733be5dee40d5a90e991c"
