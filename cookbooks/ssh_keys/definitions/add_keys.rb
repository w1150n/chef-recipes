define :add_keys do

  config = params[:conf]
  name = params[:name]
  keys = Hash.new

  if config[:group].to_s.eql?("admin")
    keys[name] = node[:ssh_keys][name]
  else
    users=data_bag('keys_catalog')
    users_keys=Array.new

    users.each do |user|
      user_data=data_bag_item('keys_catalog',user)
      if (user_data["guest"] && user_data["servers"].include?(node[:fqdn]) || user_data["guest"].eql?(nil) || user_data["guest"]==false)
        users_keys << user_data["ssh_key"]
      end
    end

    users_keys << node[:ssh_keys][name] unless node[:ssh_keys].nil?
    keys[name] = users_keys

    keys[name].flatten!
    keys[name].uniq!
    keys[name]
  end

  template "/home/#{name}/.ssh/authorized_keys" do
    source "authorized_keys.erb"
    action :create
    cookbook "ssh_keys"
    owner name
    group (config[:group]).to_s
    variables(:keys => keys)
    mode 0600
  end
end
