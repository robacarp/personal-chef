use_inline_resources

action :create do
  state = new_resource

  home_dir      = state.home_path || "/home/#{state.username}"
  create_dotssh = state.private_key || state.public_key || state.authorized_key_url || state.authorized_keys

  user state.username do
    action :create
    uid state.uid if state.uid

    supports manage_home: true
    username state.username
    password state.password
    shell state.shell
    home home_dir if state.create_home
  end

  if state.create_group
    group state.uid do
      action :create
      append false
      members state.username
      gid state.gid if state.gid
      group_name state.username
    end
  end

  if create_dotssh

    directory "#{home_dir}/.ssh" do
      recursive true
      owner state.username
    end

    if state.public_key
      file "#{home_dir}/.ssh/id_rsa.pub" do
        sensitive true
        backup false
        action :create

        mode 0600
        owner state.username
        content state.public_key
      end
    end

    if state.private_key
      file "#{home_dir}/.ssh/id_rsa" do
        sensitive true
        backup false
        action :create

        mode 0600
        owner state.username
        content state.private_key
      end
    end

    if state.authorized_keys
      file "#{home_dir}/.ssh/authorized_keys" do
        action :create
        sensitive true
        backup false
        mode 0600
        owner state.username

        content Array(state.authorized_keys).join("\n")
      end
    end

    if state.authorized_key_url
      remote_file "#{home_dir}/.ssh/authorized_keys" do
        action :create
        sensitive true
        backup false
        mode 0600
        owner state.username

        source state.authorized_key_url
      end
    end

  end

end
