default[:postgres][:version] = '9.4.5'
default[:postgres][:basename] = "postgresql-#{node[:postgres][:version]}"
default[:postgres][:tar_filename] = "postgres-#{node[:postgres][:version]}.tar.gz"
default[:postgres][:url] = "https://ftp.postgresql.org/pub/source/v#{node[:postgres][:version]}/postgresql-9.4.5.tar.gz"
default[:postgres][:sha] = 'aa1d7918ae782a0fc5e1886fd463fc8903e5ffc3eb6d3b51500065aec988a210'

default[:postgres][:user] = 'postgres'
