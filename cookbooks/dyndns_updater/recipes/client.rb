user_base_pc_user node[:dyndns][:user] do
  username node[:dyndns][:user]
  password SecureRandom.hex(rand(64))
  shell '/bin/bash'
  create_group true

  private_key node[:dyndns][:private_key]
  public_key node[:dyndns][:public_key]
end

servers = %w|ns1.code2359.com ns2.code2359.com|

servers.each do |name|
  cron "dyn_updater pointed at #{name}" do
    minute '*'
    command "curl 'http://api.ipify.org/?format=text' 2> /dev/null | ssh -i /home/#{node[:dyndns][:user]}/.ssh/id_rsa #{node[:dyndns][:user]}@#{name}  'cat > #{node[:dyndns][:install_path]}/#{node[:dyndns][:zone]}.dyndns.status'"
    user node[:dyndns][:user]
  end
end
