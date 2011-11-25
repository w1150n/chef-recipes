include_recipe "jruby::default"

execute "#{node[:jruby][:bin_path]}/jruby -S gem install trinidad" do
  not_if "#{node[:jruby][:bin_path]}/jruby -S gem list --local | grep trinidad"
end

group node[:trinidad][:daemon_user]

user node[:trinidad][:daemon_user] do
  comment "Trinidad daemon user"
  home node[:trinidad][:applications_home]
  shell "/bin/bash"
  gid node[:trinidad][:daemon_user]
end

directory "/var/log/trinidad/" do
  owner node[:trinidad][:daemon_user]
  group node[:trinidad][:daemon_user]
  mode "0755"
end

directory "/var/run/trinidad" do
  owner node[:trinidad][:daemon_user]
  group node[:trinidad][:daemon_user]
  mode "0755"
end

directory "/etc/trinidad" do
  owner "root"
  group "root"
  mode "0755"
end

#template "/etc/trinidad/trinidad.yml" do
#  source "trinidad.yml.erb"
#  mode "0755"
#  owner "root"
#  group "root"
#end

execute "#{node[:jruby][:bin_path]}/jruby -S gem install trinidad_daemon_extension" do
  not_if "#{node[:jruby][:bin_path]}/jruby -S gem list --local | grep trinidad_daemon_extension"
end

template "/etc/init.d/trinidad" do
  owner "root"
  group "root"
  mode "0755"
  source "trinidad-init.erb"
end

template "/usr/local/bin/trinidad" do
  owner "root"
  group "root"
  mode "0755"
  source "trinidad.erb"
end

trinidad = service "trinidad" do
  action :enable
end

