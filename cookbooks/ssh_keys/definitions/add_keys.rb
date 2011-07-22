define :add_keys do

  keys = Hash.new

  if params[:group].to_s.eql?("admin")
    keys[params[:name]] = node[:ssh_keys][params[:name]]
  else
    users=data_bag('keys_catalog')
    users_keys=Array.new

    users.each do |user|
      user_data=data_bag_item('keys_catalog',user)
      if (user_data["guest"] && user_data["servers"].include?(node[:fqdn]) || user_data["guest"].eql?(nil) || user_data["guest"]==false)
        users_keys << user_data["ssh_key"]
      end
    end

    keys[params[:name]] = users_keys
    keys[params[:name]].flatten!
    keys[params[:name]].uniq!
    keys[params[:name]]
  end

  template "/home/#{params[:name]}/.ssh/authorized_keys" do
    source "authorized_keys.erb"
    action :create
    cookbook "ssh_keys"
    owner params[:name]
    group params[:group]
    variables(:keys => keys)
    mode 0600
  end
end
