use_inline_resources


action :write do

  template ::File.join(new_resource.location, new_resource.name) do
    action :create
    source 'zone-file.erb'
    cookbook 'nsd'

    owner 'nsd'
    group 'nsd'
    mode 0640

    variables(
      :zone => new_resource.zone
    )
  end

end
