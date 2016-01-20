boolean = [TrueClass, FalseClass]

attribute :location, kind_of: String, default: "/etc/nsd/zones"
attribute :zone, kind_of: Hash

actions :write
default_action :write
