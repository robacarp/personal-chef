use_inline_resources

def sites_available
  "#{node[:nginx][:config_dir]}/sites-available/#{new_resource.name}" 
end

def sites_enabled
  "#{node[:nginx][:config_dir]}/sites-enabled/#{new_resource.name}" 
end

action :create do
  template sites_available do
    source 'site_config.erb'
    cookbook 'nginx'
    variables(
      default: new_resource.default,
      index: new_resource.index,
      name: new_resource.name,
      port: new_resource.port,
      root: new_resource.root
    )
  end

  directory new_resource.root

  link sites_enabled do
    to sites_available

    if new_resource.enabled
      action :create
    else
      action :delete
    end
  end
end
