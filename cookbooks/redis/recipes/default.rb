repository "ppa:verwilst/ppa"

add_apt_preferences "*" do
  packages ["*"]
  pin "release o=LP-PPA-verwilst, a=#{node[:lsb][:codename]}"
  pin_priority "200"
end

add_apt_preferences "redis-server" do
  packages ["redis-server"]
  pin "release o=LP-PPA-verwilst, a=#{node[:lsb][:codename]}"
  pin_priority "990"
end

package "redis-server" do
  action :upgrade
end
