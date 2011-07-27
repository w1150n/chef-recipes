include_recipe 'passenger::passenger-dependencies'

passengerroot="#{node[:languages][:ruby][:gems_dir]}/gems/passenger-#{node[:passenger][:version]}"
mod="#{node[:languages][:ruby][:gems_dir]}/gems/passenger-#{node[:passenger][:version]}/ext/apache2/mod_passenger.so"

gem_package "passenger" do
  gem_binary node[:passenger][:compiled][:gem_path]
  action :install
  version node[:passenger][:version]
  options("-n /usr/bin")
end

execute "install-passenger" do
  command "#{node[:passenger][:compiled][:install_binary]} -a"
  not_if "test -f #{mod}"
end

template "#{node[:apache][:dir]}/mods-available/passenger.load" do
  source "mods/passenger.load.erb"
  owner "root"
  group "root"
  mode "0644"
  variables( :passengermodule => mod)
end

options = {
  :passengerroot => passengerroot,
  :passengerruby => node[:passenger][:compiled][:passengerruby] }

apache_module "passenger" do
  conf true
  module_options options
end

template "#{node[:apache][:dir]}/mods-available/passenger.load" do
  source "mods/passenger.load.erb"
  owner "root"
  group "root"
  mode "0644"
  variables( :passengermodule => mod)
end
