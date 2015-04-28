actions :create
default_action :create

stringable = [String, Symbol]
boolean = [TrueClass, FalseClass]

attribute :uid
attribute :username,           kind_of: stringable, required: true, name_attribute: true
attribute :password,           kind_of: String, default: ''
attribute :shell,              kind_of: String, default: '/bin/bash'
attribute :home_path,          kind_of: String, default: nil

attribute :public_key,         kind_of: String, default: nil
attribute :private_key,        kind_of: String, default: nil
attribute :authorized_key_url, kind_of: [Array, String], default: nil
attribute :authorized_keys,    kind_of: [Array, String], default: nil

attribute :create_home,        kind_of: boolean, default: true
attribute :create_group,       kind_of: boolean, default: false
attribute :system_account,     kind_of: boolean, default: false

def initialize(*args)
  super
  @resource_name = :pc_user
  @action = :create
end
