packages = %w| build-essential libevent-dev libssl-dev |

packages.each do |p|
  package p do
    action :install
  end
end

directory '/root/src'

local_path = Chef::Config[:file_cache_path]
tar_path = "#{local_path}/#{node[:nsd][:tar]}"
untar_path = "#{local_path}/#{node[:nsd][:basename]}"

remote_file "nsd source" do
  source node[:nsd][:url]
  path tar_path

  action :create_if_missing
end

bash "untar" do
  code  <<-SH
    cd #{local_path} && \
    tar xzf #{node[:nsd][:tar]}
  SH

end

bash "configure-compile" do
  code <<-SH
    cd #{untar_path}
    ./configure && \
    make && \
    make install
  SH

end

user 'nsd' do
  system true
  shell '/bin/false'
  home '/home/nsd'
end

group 'nsd' do
  system true
  members 'nsd'
end

directory "/var/db"
directory "/var/db/nsd" do
  user 'nsd'
  group 'nsd'
end

directory "/var/run"
directory "/var/run/nsd" do
  user 'nsd'
  group 'nsd'
end

execute "/usr/local/sbin/nsd-control-setup"

zones = []
data_bag("dns").each do |item|
  zones.push data_bag_item("dns",item)
end

template '/etc/nsd/nsd.conf' do
  action :create
  source 'nsd-conf.erb'
  mode '0600'
  owner 'nsd'
  group 'nsd'

  variables(
    :zones => zones
  )
end

directory "/etc/nsd/zones" do
  action :create
  mode 0755
  recursive true
end

zones.each do |zone|
  template "/etc/nsd/zones/#{zone["file_name"]}" do
    action :create
    source 'zone-file.erb'
    owner 'nsd'
    group 'nsd'
    mode 0640

    variables(
      :zone => zone
    )

  end
end

template "/etc/init.d/nsd" do
  source "nsd-init.erb"
  mode "0755"
  action :create
end

service "nsd" do
  supports(
    start: true,
    stop: true,
    restart: true,
    reload: true,
    notify: true,
    upload: true
  )

  action [:enable, :start]
end

# execute '/etc/init.d/nsd start' do
#   ignore_failure true
# end
# 
# execute '/etc/init.d/nsd start' do
#   ignore_failure true
# end
