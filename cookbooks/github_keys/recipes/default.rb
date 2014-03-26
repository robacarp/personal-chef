%w| /root/.ssh/known_hosts |.each do |known_host_file|
  file known_host_file do
    action :create_if_missing
  end

  github_key = `ssh-keyscan -H github.com`

  ruby_block "dump github public keys into known hosts file" do
    block do
      file = Chef::Util::FileEdit.new( known_host_file )
      file.insert_line_if_no_match(github_key, github_key)
      file.write_file
    end
  end
end
