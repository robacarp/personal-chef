include_recipe 'apt'

postgres_installed = "ruby -v | grep #{ node[:postgres][:version] }"

%w().each do |pkg|
  package pkg do
    action :install
  end
end

directory '/root/src' do
  action :create
end

remote_file 'download postgres source from remote' do
  not_if postgres_installed

  source node[:postgres][:url]
  path '/root/src/' + node[:postgres][:tar_filename]
  checksum node[:postgres][:checksum]
  action :create_if_missing
end

bash "untar postgres source" do
  not_if postgres_installed

  code <<-SH
    cd /root/src && \
    tar xzf #{node[:postgres][:tar_filename]}
  SH
end

bash "configure and compile postgres source" do
  not_if postgres_installed

  code <<-SH
    cd /root/src/#{node[:postgres][:basename]}
    ./configure --disable-install-doc \
                --bindir=/usr/local/bin \
                --sysconfdir=/etc \
                --datarootdir=/usr/local/share \
                \
                --with-openssl \
    && \
    make
  SH
end

bash "install postgres" do
  not_if postgres_installed

  code <<-SH
    cd /root/src/#{node[:postgres][:basename]}
    make install
  SH
end

template "/etc/init.d/postgresql" do
  source "postgresql.conf.erb"
end

user node[:postgres][:user] do
  system true
  shell 'nologin'
  manage_home false
  home '/var/www'
end

