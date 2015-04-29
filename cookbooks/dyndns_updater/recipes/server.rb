directory node[:dyndns][:install_path] do
  recursive true
end

template "#{node[:dyndns][:install_path]}/dns-updater.rb" do
  source "dns-updater.rb.erb"
  mode "0755"
  action :create

  variables(
    :zone => node[:dyndns][:zone],
    :dir  => node[:dyndns][:install_path]
  )
end

template "#{node[:dyndns][:install_path]}/#{node[:dyndns][:zone]}.zonefile.template" do
  source 'zonefile.template'
end

user node[:dyndns][:user] do
  action :create
  supports manage_home: true
  username node[:dyndns][:user]
  password SecureRandom.hex(rand(64))
  shell '/bin/bash'
  home '/home/dyndns'
end

group node[:dyndns][:user] do
  action :create
  append false
  members node[:dyndns][:user]
end

directory "/home/#{node[:dyndns][:user]}/.ssh" do
  recursive true
  owner node[:dyndns][:user]
  group node[:dyndns][:user]
end

file "/home/#{node[:dyndns][:user]}/.ssh/authorized_keys" do
  owner node[:dyndns][:user]
  group node[:dyndns][:user]
  backup false
  content <<-END
no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty,command="cat > #{node[:dyndns][:install_path]}/#{node[:dyndns][:zone]}.dyndns.status" #{node[:dyndns][:public_key]}
  END
  sensitive true
end

cron :dyn_updater do
  # minute '*/5'
  command "cd #{node[:dyndns][:install_path]}; /usr/local/bin/ruby #{node[:dyndns][:install_path]}/dns-updater.rb"
  user 'root'
end

file "#{node[:dyndns][:install_path]}/#{node[:dyndns][:zone]}.dyndns.last" do
  action :delete
end
