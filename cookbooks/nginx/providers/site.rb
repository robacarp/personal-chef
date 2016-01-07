use_inline_resources

def sites_available
  "#{node[:nginx][:config_dir]}/sites-available/#{new_resource.name}"
end

def sites_enabled
  "#{node[:nginx][:config_dir]}/sites-enabled/#{new_resource.name}"
end

action :create do

  proxy_name = [new_resource.name, :proxy].join('_').gsub(/[^0-9a-zA-Z]/,'_')
  proxy_name = '@' + proxy_name

  log_dir = [node[:nginx][:log_dir], new_resource.name].join('/')

  template sites_available do
    source 'site_config.erb'
    cookbook 'nginx'
    variables(
      resource: new_resource,
      proxy_name: proxy_name,
      log_dir: log_dir
    )
  end

  directory new_resource.root
  directory [node[:nginx][:log_dir], new_resource.name].join('/')

  link sites_enabled do
    to sites_available

    if new_resource.enabled
      action :create
    else
      action :delete
    end
  end
end
