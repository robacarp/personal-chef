users = []
data_bag("users").each do |user|
  users.push data_bag_item("users", user).to_hash
end

options = [
  :uid, :username, :password, :shell,
  :home_path, :public_key, :private_key,
  :authorized_key_url, :authorized_keys,
  :create_home, :create_group, :system_account
]

users.each_with_index do |user, i|

  user_base_pc_user user[:id] do
    options.each do |option|
      if user[option.to_s] && respond_to?(option)
        send option, user[option]
      end
    end
  end

  sudoers << user if u['groups'].include? 'sudo'
end

group "sudo" do
  append true
  group_name "sudo"
  members sudoers
end
