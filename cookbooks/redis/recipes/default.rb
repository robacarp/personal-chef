local_path = Chef::Config[:file_cache_path]
tar_path = "#{local_path}/#{node[:redis][:tar]}"
untar_path = "#{local_path}/#{node[:redis][:basename]}"

remote_file 'redis source' do
  source node[:redis][:url]
  path tar_path
end

bash 'untar' do
  code <<-SH
  cd #{local_path} && \
  tar xzf #{node[:redis][:tar]}
  SH

  # not_if {
  #   File.exist? File.join(local_path, node[:redis][:basename])
  # }
end

bash 'configure-compile' do
  code <<-SH
    cd #{untar_path}
    touch config-compile-run
    make install && \
    touch compile-success
  SH

  creates File.join(untar_path,'src/redis-server')
end

template '/etc/init.d/redis-server' do
  source 'redis.init.erb'
  mode 0755
  action :create
end

directory '/etc/redis' do
  action :create
  mode 0744
end

template '/etc/redis/6379.conf' do
  source 'redis.conf.erb'
  mode 0600
end
