default[:ruby][:version] = '2.0.0-p247'
default[:ruby][:basename] = "ruby-#{node[:ruby][:version]}"
default[:ruby][:tar_filename] = "#{node[:ruby][:basename]}.tar.gz"
default[:ruby][:url] = "http://ftp.ruby-lang.org/pub/ruby/stable/#{node[:ruby][:tar_filename]}"
default[:ruby][:sha] = '3e71042872c77726409460e8647a2f304083a15ae0defe90d8000a69917e20d3'


