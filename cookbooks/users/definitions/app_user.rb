define :app_user, :site_options => { } do

  site_options=params[:site_options]

  package "libshadow-ruby1.8" do
    action :install
  end

  group site_options[:user]

  user site_options[:user] do
    comment "#{site_options[:user]} application user"
    home "/home/#{site_options[:user]}"
    shell "/bin/bash"
    supports :manage_home => true
    password ""
    action [  :create, :modify, :manage ]
    gid site_options[:user]
  end

  group "adm" do
    members site_options[:user]
    append true
  end

  directory "/home/#{site_options[:user]}/.ssh" do
    action :create
    owner site_options[:user]
    group site_options[:user]
    mode 0700
  end

  options={ :group => site_options[:user] }

  add_keys site_options[:user] do
    conf options
  end
end
