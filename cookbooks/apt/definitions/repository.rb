define :repository do

include_recipe "apt"

  directory "/etc/apt/sources.list.d/" do
    action :create
    owner "root"
    group "root"
    mode "0755"
  end

  remote_file "/etc/apt/sources.list.d/#{params[:name]}.list" do
    params[:config_url] ? (source params[:config_url]) : (source params[:name])
    owner "root"
    group "root"
    mode "0644"
    action :create
  end

  remote_file "/tmp/#{params[:name]}-apt.key" do
    params[:key_url] ?  (source params[:key_url])  : (source "#{params[:name]}.key")
  end

  execute "apt-key add /tmp/#{params[:name]}-apt.key" do
    creates "/var/tmp/.add-key-#{params[:name]}"
    notifies :run, resources(:execute => "apt-get update"), :immediately
  end

  file "/var/tmp/.add-key-#{params[:name]}"
end
