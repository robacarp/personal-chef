include_recipe 'apt'

php_installed = "ls #{node[:php][:binary_path]}/php"

%w( libssl-dev libpcre3-dev libxml2-dev libjpeg-dev libreadline-dev libpng-dev libpq-dev ).each do |pkg|
  package pkg do
    action :install
  end
end

directory '/root/src'

remote_file 'download php source from remote' do
  not_if php_installed

  source node[:php][:url]
  path '/root/src/' + node[:php][:tar_filename]
  checksum node[:php][:checksum]
  action :create_if_missing
end

bash "untar php source" do
  not_if php_installed

  code <<-SH
    cd /root/src && \
    tar xf #{node[:php][:tar_filename]}
  SH
end

bash "configure and compile php source" do
  not_if php_installed

    #            --with-apxs2=/usr/sbin/apxs2 \
    #            --with-mysql \

  code <<-SH
    cd /root/src/#{node[:php][:basename]}
    ./configure --with-pgsql \
                --with-zlib \
                --with-gd \
                --with-jpeg-dir \
                --with-iconv-dir \
                --enable-mbstring \
    && \
    make
  SH
end

bash "install php" do
  not_if php_installed

  code <<-SH
    cd /root/src/#{node[:php][:basename]}
    make install
  SH
end
