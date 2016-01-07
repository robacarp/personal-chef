default[:nginx][:version] = '1.9.9'
default[:nginx][:basename] = 'nginx-1.9.9'
default[:nginx][:url] = 'http://nginx.org/download/nginx-1.9.9.tar.gz'
default[:nginx][:tar_filename] = 'nginx-1.9.9.tar.gz'
default[:nginx][:sha] = 'de66bb2b11c82533aa5cb5ccc27cbce736ab87c9f2c761e5237cda0b00068d73'

default[:nginx][:config_dir] = '/etc/nginx'
default[:nginx][:binary_path] = '/usr/local/sbin'
default[:nginx][:pid_path] = '/var/run/nginx.pid'
default[:nginx][:log_dir] = '/var/log/nginx'
default[:nginx][:error_log] = "#{node[:nginx][:log_dir]}/error.log"
default[:nginx][:access_log] = "#{node[:nginx][:log_dir]}/access.log"
default[:nginx][:user] = 'www-data'
