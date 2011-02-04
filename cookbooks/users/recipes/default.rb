if node[:languages][:ruby][:version] == "1.9.2"
  include_recipe "ruby-shadow-1.9.2"

elsif node[:languages][:ruby][:version] =~ /1.8.[0-9]/
  package "libshadow-ruby1.8" do
    action :install
  end
end

node[:users].each do |u, config|

  user u do
    comment config[:comment]
    home "/home/#{u}"
    shell "/bin/bash"
    password config[:password]
    supports :manage_home => true
    action :create
  end

  if config[:group].eql?(:admin)
    group "admin" do
      members [ u ]
      action :create
      append true
    end
  end

  directory "/home/#{u}/.ssh" do
    action :create
    owner u
    group config[:group].to_s
    mode 0700
  end

  add_keys u do
    conf config
  end

end

require_recipe "sudo"
