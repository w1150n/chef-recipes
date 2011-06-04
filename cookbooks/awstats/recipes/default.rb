package "awstats" do
  action :upgrade
end

web_app "awstats" do
  template "awstats_apache.conf.erb"
  server_name node[:awstats][:server_name]
  docroot  "/var/lib/awstats"
end


