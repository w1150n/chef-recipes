include_recipe "chef::client"

repository "brightbox-rubyee" do
  key_url "http://apt.brightbox.net/release.asc"
  config_url "http://apt.brightbox.net/sources/#{node[:lsb][:codename]}/rubyee-testing.list"
end

remove_apt_preferences "ruby1.8"

packages = %w(libopenssl-ruby1.8 libreadline-ruby1.8 libruby1.8 ruby1.8 ruby1.8-dev)

#packages=%w(ruby ruby-dev libruby1.8 irb1.8 libopenssl-ruby1.8 libreadline-ruby1.8 rdoc1.8 ruby1.8 ruby1.8-dev)
#packages = %w(ruby ruby-dev libopenssl-ruby libreadline-ruby librmagick-ruby librmagick-ruby1.8 ruby1.8 ruby1.8-dev libopenssl-ruby1.8 librmagick-ruby1.8 libruby1.8 libreadline-ruby1.8)

packages.each do |p|
  package p do
    action :upgrade
    options "--force-yes"
    notifies :restart, resources(:service => "chef-client")
  end
end
