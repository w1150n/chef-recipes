package "libwww-perl" do
  action :upgrade
end

package "munin-node" do
  action :upgrade
end

package "munin-plugins-extra" do
  action :upgrade
end

service "munin-node" do
  # By default, the init provider is used, which runs /etc/init.d/service_name with _command.
  supports :restart => true, :reload => true
  action :nothing
end

template "/etc/munin/munin-node.conf" do
  source "munin-node.erb"
  mode "0644"
  owner "root"
  group "root"
  notifies :restart, resources(:service => "munin-node")
end

template "/etc/munin/plugin-conf.d/munin-node" do
  source "munin-node-plugin.conf.erb"
  mode "0600"
  owner "root"
  group "root"
  notifies :restart, resources(:service => "munin-node")
end

extra = %w{ passenger_memory passenger_stats }

extra.each do |p|
  cookbook_file "/usr/share/munin/plugins/#{p}" do
    source p
    mode "0755"
  end

  link "/etc/munin/plugins/#{p}" do
    to "/usr/share/munin/plugins/#{p}"
    link_type :symbolic
    only_if "test ! -h /etc/munin/plugins/#{p}"
    notifies :restart, resources(:service => "munin-node")
  end
end

# Special config for memcached plugins

execute "rm -f /etc/munin/plugins/memcached"

cookbook_file "/usr/share/munin/plugins/memcached_" do
  source "memcached_multi_"
  mode "0755"
end

memcached_options = %w(bytes commands conns evictions items memory)
memcached_options.each do |p|
  link "/etc/munin/plugins/memcached_#{p}" do
    to "/usr/share/munin/plugins/memcached_"
    link_type :symbolic
    not_if "test -h /etc/munin/plugins/memcached_#{p}"
    notifies :restart, resources(:service => "munin-node")
  end

  execute "rm -f /etc/munin/plugins/memcached_multi_#{p}"


end

plugins = %w{ apache_accesses apache_processes apache_volume cpu df df_inode entropy forks if_err_eth0 if_err_eth1 if_eth0 if_eth1 interrupts iostat load memory mysql_queries netstat open_files open_inodes passenger_memory passenger_stats postfix_mailqueue postfix_mailvolume processes swap uptime vmstat }

uninstall = %w{ exim_mailqueue exim_mailstats irqstats ntp_europium_canonical_com }

plugins.each do |p|
  link "/etc/munin/plugins/#{p}" do
    to "/usr/share/munin/plugins/#{p}"
    link_type :symbolic
    only_if "test ! -h /etc/munin/plugins/#{p}"
    notifies :restart, resources(:service => "munin-node")
  end
end

uninstall.each do |p|
  link "/etc/munin/plugins/#{p}" do
    action :delete
    only_if "test -f /etc/munin/plugins/#{p}"
    notifies :restart, resources(:service => "munin-node")
  end
end

