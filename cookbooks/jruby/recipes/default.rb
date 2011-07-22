package "default-jre-headless" do
  action :upgrade
end

remote_file "#{node[:jruby][:extract_path]}/jruby-bin-#{node[:jruby][:version]}.tar.gz" do
  source node[:jruby][:url]
  checksum node[:jruby][:checksum]
end

execute "tar -zxvf #{node[:jruby][:extract_path]}/jruby-bin-#{node[:jruby][:version]}.tar.gz" do
  cwd "#{node[:jruby][:install_path]}"
  not_if "[ `#{node[:jruby][:bin_path]}/bin/jruby -v | awk '{print $2}'` = #{node[:jruby][:version]} ]"
end

%w(bundler rake).each do |gem|
  execute "#{node[:jruby][:bin_path]}/jruby -S gem install #{gem}" do
    not_if "`#{node[:jruby][:bin_path]}/jruby -S gem list --local` | grep #{gem}"
  end
end


template "/etc/profile.d/jruby.sh" do
  source "jruby.erb"
  mode "0755"
end
