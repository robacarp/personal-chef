include_recipe 'apt'

ruby_installed = "ruby -v | grep #{ node[:ruby][:version] }"

%w( autoconf zlib1g-dev libssl-dev libffi-dev libxml2-dev libncurses-dev libreadline-dev libyaml-0-2 libyaml-dev ).each do |pkg|
  package pkg do
    action :install
  end
end

directory '/root/src' do
  action :create
end

remote_file 'download ruby source from remote' do
  not_if ruby_installed

  source node[:ruby][:url]
  path '/root/src/' + node[:ruby][:tar_filename]
  checksum node[:ruby][:checksum]
  action :create_if_missing
end

bash "untar ruby source" do
  not_if ruby_installed

  code <<-SH
    cd /root/src && \
    tar xzf #{node[:ruby][:tar_filename]}
  SH
end

bash "configure and compile ruby source" do
  not_if ruby_installed

  code <<-SH
    cd /root/src/#{node[:ruby][:basename]}
    autoconf && \
    ./configure --disable-install-doc && \
    make
  SH
end

bash "install ruby" do
  not_if ruby_installed

  code <<-SH
    cd /root/src/#{node[:ruby][:basename]}
    make install
  SH
end
