boolean = [TrueClass, FalseClass]

attribute :enabled, kind_of: boolean, default: true

attribute :root, kind_of: String, default: "/var/www/"
attribute :default, kind_of: boolean, default: false
attribute :index, kind_of: String, default: "index.html index.htm"
attribute :name, kind_of: String, default: "localhost"
attribute :port, kind_of: Fixnum, default: 80

attribute :enable_php, kind_of: boolean, default: false
attribute :proxy_to, kind_of: String, default: false

attribute :forward_unencrypted, kind_of: boolean, default: true

actions :create
default_action :create
