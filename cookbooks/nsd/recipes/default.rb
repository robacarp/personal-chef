packages = %w| build-essential libevent-dev libssl-dev |

packages.each do |p|
  package p do
    action :install
  end
end

local_path = Chef::Config[:file_cache_path]
tar_path = "#{local_path}/#{node[:nsd][:tar]}"
untar_path = "#{local_path}/#{node[:nsd][:basename]}"

remote_file "nsd source" do
  source node[:nsd][:url]
  path tar_path
  checksum node[:nsd][:checksum]
end

bash "untar" do
  code  <<-SH
    cd #{local_path} && \
    tar xzf #{node[:nsd][:tar]}
  SH

  not_if { File.exist? "#{local_path}/#{node[:nsd][:basename]}" }
  notifies :run, 'execute[stop nsd]', :immediately
end

execute 'stop nsd' do
  command 'nsd-control stop'
  action :nothing
  only_if { Dir['/var/run/nsd/*.pid'].any? }
end

bash "configure-compile" do
  code <<-SH
    cd #{untar_path}
    touch configure-compile-run
    ./configure && \
    make && \
    make install
  SH

  creates "#{untar_path}/nsd"
  notifies :run, 'bash[nsd control setup]', :immediately
end

bash 'nsd control setup' do
  code <<-SH
    nsd-control-setup
    touch #{local_path}/control-setup-ran
  SH

  creates '/etc/nsd/nsd_control.pem'
  action :nothing
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

template "/etc/init.d/nsd" do
  source "nsd-init.erb"
  mode "0755"
  action :create
end

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

  notifies :run, 'execute[reload_nsd]', :delayed
end

execute 'reload_nsd' do
  command 'nsd-control stop'
  command 'nsd-control start'
  action :nothing
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

    notifies :run, 'execute[reload_nsd]', :delayed
  end
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
