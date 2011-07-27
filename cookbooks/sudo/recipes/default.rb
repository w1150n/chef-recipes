package "sudo" do
  action :upgrade
end

cookbook_file "/etc/sudoers" do
  source "sudoers"
  mode 0440
  owner "root"
  group "root"
end
