restricted_authorized_key = <<-KEY
no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty,command="cat > #{node[:dyndns][:install_path]}/#{node[:dyndns][:zone]}.dyndns.status" #{node[:dyndns][:public_key]}
KEY

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

cookbook_file "#{node[:dyndns][:install_path]}/#{node[:dyndns][:zone]}.zonefile.template" do
  source 'zonefile.template'
end

user_base_pc_user node[:dyndns][:user] do
  username node[:dyndns][:user]
  password SecureRandom.hex(rand(64))
  shell '/bin/bash'
  create_group true

  authorized_keys restricted_authorized_key
end

cron :dyn_updater do
  # minute '*/5'
  command "cd #{node[:dyndns][:install_path]}; /usr/local/bin/ruby #{node[:dyndns][:install_path]}/dns-updater.rb"
  user 'root'
end

# force the next cron run to update the zonefile
file "#{node[:dyndns][:install_path]}/#{node[:dyndns][:zone]}.dyndns.last" do
  action :delete
end
