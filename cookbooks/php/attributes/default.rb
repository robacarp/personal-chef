default[:php][:version] = '5.6.17'
default[:php][:basename] = 'php-5.6.17'
default[:php][:url] = 'http://us1.php.net/get/php-5.6.17.tar.gz/from/this/mirror'
default[:php][:tar_filename] = 'php-5.6.17.tar.gz'
default[:php][:sha] = '556121271a34c442b48e3d7fa3d3bbb4413d91897abbb92aaeced4a7df5f2ab2'

default[:php][:config_dir] = '/etc/php'
default[:php][:binary_path] = '/usr/local/sbin'
default[:php][:pid_path] = '/var/run/php.pid'
default[:php][:log_dir] = '/var/log/php'
default[:php][:error_log] = "#{node[:php][:log_dir]}/error.log"
default[:php][:access_log] = "#{node[:php][:log_dir]}/access.log"
default[:php][:user] = 'www-data'
