packages = %w|build-essential mailutils mosh vim ntp|

packages.each do |p|
  package p
end


if node[:set_hostname]
  puts node[:set_hostname]

  file '/etc/hostname' do
    content node[:set_hostname]
    notifies :run, 'execute[set hostname]', :immediately
  end

  execute 'set hostname' do
    command 'hostname --file /etc/hostname'
    action :nothing
  end
end
