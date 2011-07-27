users=data_bag('keys_catalog')
users_http_passwords={ }

users.each do |user|
  user_data=data_bag_item('keys_catalog', user)
  users_http_passwords.store(user, user_data["http_passwd"]) if user_data["http_passwd"]
end

template "#{node[:apache][:dir]}/passwords" do
  source "passwords.erb"
  mode "0644"
  owner "root"
  group "root"
  variables(:users_http_passwords => users_http_passwords)
end
