users = []
data_bag("users").each do |user|
  users.push data_bag_item("users", user).to_hash
end

users.each_with_index do |user, i|
  user user['id'] do
    action :create
    username user['id']
    password user['password']
    shell user['shell'] || '/bin/bash'
    home user['home']
    uid user['uid']
  end

  group user['uid'] do
    action :create
    append false
    members user['id']
    gid user['gid']
    group_name user['id']
  end

  directory "#{user['home']}/.ssh" do
    recursive true
  end

  public_keys = ""
  if user['public_key_url']
    remote_file "#{user['home']}/.ssh/authorized_keys" do
      source user['public_key_url']
      checksum user['checksum'] if user['checksum']

      action :create_if_missing
      owner user['uid']
      group user['gid']
      backup false
    end
  end

  # mayhaps allow some sort of data-bag based public key?
  # file "#{user['home']}/.ssh/authorized_keys" do
  # end
end

sudoers = users.select {|u| u['groups'].include? "sudo"}
               .map    {|u| u['id'] }
               .join(',')

group "sudo" do
  append true
  group_name "sudo"
  members sudoers
end
