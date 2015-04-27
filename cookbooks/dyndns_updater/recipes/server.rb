template "#{node[:dyndns][:install_path]}/dns-updater.rb" do
  source "dns-updater.rb.erb"
  mode "0755"
  action :create

  variables(
    :zone => node[:dyndns][:zone]
  )
end
