define :repository do

  include_recipe "apt::default"

  directory "/etc/apt/sources.list.d/" do
    action :create
    owner "root"
    group "root"
    mode "0755"
  end

  if params[:name].include?("ppa:")
    if params[:name].include?("+")

      sources_original=params[:name].gsub("ppa:","").gsub("/","-")
      sources_list=params[:name].gsub("+","-").gsub("ppa:","").gsub("/","-")

      execute "sudo add-apt-repository #{params[:name]}" do
        creates "/etc/apt/sources.list.d/#{sources_list}-#{node[:lsb][:codename]}.list"
      end

      execute "mv /etc/apt/sources.list.d/#{sources_original}-#{node[:lsb][:codename]}.list /etc/apt/sources.list.d/#{sources_list}-#{node[:lsb][:codename]}.list" do
        creates "/etc/apt/sources.list.d/#{sources_list}-#{node[:lsb][:codename]}.list"
        notifies :run, resources(:execute => "apt-get update"), :immediately
      end
    else

      execute "sudo add-apt-repository #{params[:name]}" do
        creates "/etc/apt/sources.list.d/#{sources_list}-#{node[:lsb][:codename]}.list"
        notifies :run, resources(:execute => "apt-get update"), :immediately
      end
    end
  else

    remote_file "/tmp/#{params[:name]}-apt.key" do
      params[:key_url] ?  (source params[:key_url])  : (source "#{params[:name]}.key")
    end

    execute "apt-key add /tmp/#{params[:name]}-apt.key" do
      creates "/var/tmp/.add-key-#{params[:name]}"
    end

    file "/var/tmp/.add-key-#{params[:name]}"

    remote_file "/etc/apt/sources.list.d/#{params[:name]}.list" do
      params[:config_url] ? (source params[:config_url]) : (source params[:name])
      owner "root"
      group "root"
      mode "0644"
      action :create
      notifies :run, resources(:execute => "apt-get update"), :immediately
    end
  end
end
