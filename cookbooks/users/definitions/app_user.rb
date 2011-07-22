define :app_user do

  package "libshadow-ruby1.8" do
    action :install
  end

  group params[:name]

  user params[:name] do
    comment "#{params[:name]} application user"
    home "/home/#{params[:name]}"
    shell "/bin/bash"
    supports :manage_home => true
    password ""
    action [  :create, :modify, :manage ]
    gid params[:name]
  end

  group "adm" do
    members params[:name]
    append true
  end

  directory "/home/#{params[:name]}" do
    action :create
    owner params[:name]
    group params[:name]
    mode "0755"
  end

  directory "/home/#{params[:name]}/.ssh" do
    action :create
    owner params[:name]
    group params[:name]
    mode 0700
  end

  add_keys params[:name] do
    group params[:name]
  end
end
