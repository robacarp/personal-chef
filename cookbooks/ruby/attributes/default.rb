default[:ruby][:version] = '2.2.2'
default[:ruby][:basename] = "ruby-#{node[:ruby][:version]}"
default[:ruby][:tar_filename] = "#{node[:ruby][:basename]}.tar.gz"
default[:ruby][:url] = "http://cache.ruby-lang.org/pub/ruby/2.2/#{node[:ruby][:tar_filename]}"
default[:ruby][:sha] = '5ffc0f317e429e6b29d4a98ac521c3ce65481bfd22a8cf845fa02a7b113d9b44'
