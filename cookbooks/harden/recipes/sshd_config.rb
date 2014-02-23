template '/etc/ssh/sshd_config' do
  action :create
  source 'sshd_config.erb'
  mode 0644
end

service 'ssh' do
  action :restart
end
