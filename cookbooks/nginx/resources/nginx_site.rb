attribute :root, kind_of: String, default: "/var/www/"
attribute :default, kind_of: [TrueClass, FalseClass], default: false
attribute :index, kind_of: String, default: "index.html index.htm"
attribute :name, kind_of: String, default: "localhost"
attribute :port, kind_of: Fixnum, default: 80
attribute :enabled, kind_of: [TrueClass, FalseClass], default: true

actions :create
default_action :create

provides :nginx_site
