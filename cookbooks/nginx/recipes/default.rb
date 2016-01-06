include_recipe 'apt'

nginx_installed = "ls #{node[:nginx][:binary_path]}/nginx"

%w( libssl-dev libpcre3-dev ).each do |pkg|
  package pkg do
    action :install
  end
end

directory '/root/src'

remote_file 'download nginx source from remote' do
  not_if nginx_installed

  source node[:nginx][:url]
  path '/root/src/' + node[:nginx][:tar_filename]
  checksum node[:nginx][:checksum]
  action :create_if_missing
end

bash "untar nginx source" do
  not_if nginx_installed

  code <<-SH
    cd /root/src && \
    tar xzf #{node[:nginx][:tar_filename]}
  SH
end

bash "configure and compile nginx source" do
  not_if nginx_installed

  code <<-SH
    cd /root/src/#{node[:nginx][:basename]}
    ./configure --prefix=#{node[:nginx][:config_dir]} \
                --sbin-path=#{node[:nginx][:binary_path]} \
                --conf-path=#{node[:nginx][:config_dir]}/nginx.conf \
                --pid-path=#{node[:nginx][:pid_path]} \
                --error-log-path=#{node[:nginx][:error_log]} \
                --http-log-path=#{node[:nginx][:access_log]} \
                --user=#{node[:nginx][:user]} \
    && \
    make
  SH
end

bash "install nginx" do
  not_if nginx_installed

  code <<-SH
    cd /root/src/#{node[:nginx][:basename]}
    make install
  SH
end

user node[:nginx][:user] do
  system true
  shell 'nologin'
  manage_home false
  home '/var/www'
end

directory '/var/www'

directory '/etc/nginx/sites-available'
directory '/etc/nginx/sites-enabled'
directory '/var/log/nginx'

template '/etc/nginx/nginx.conf'

template '/etc/init.d/nginx' do
  source 'etc/init.d/nginx.erb'
  mode 0755
end

bash "enable init.d" do
  code <<-SH
    update-rc.d nginx defaults
  SH
end

template '/etc/nginx/sites-available/default' do
  source 'sites-available/default.erb'
end

link '/etc/nginx/sites-enabled/default' do
  to '/etc/nginx/sites-available/default'
end

service 'nginx' do
  action [:enable, :start]
  supports({
    :restart => true,
    :reload => true,
    :status => false
  })
end
