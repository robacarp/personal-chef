packages = %w|build-essential mailutils mosh vim ntp|

packages.each do |p|
  package p
end


if node[:hostname]
  file '/etc/hostname' do
    content node[:hostname]
  end
end
