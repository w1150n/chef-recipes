# -*- coding: utf-8 -*-
define :awstats_domain, :logtype => "W", :logformat => "4" do

  include_recipe "awstats::default"

  aliases = (params[:aliases] | ["localhost", "127.0.0.1" ]).join

  template "/etc/awstats/awstats.#{params[:name]}.conf" do
    source "awstats.conf.erb"
    cookbook "awstats"
    owner "root"
    group "root"
    mode "0755"
    variables(:name => params[:name],
              :logtype => params[:logtype],
              :domain => params[:domain],
              :logfile => params[:logfile],
              :logformat => params[:logformat],
              :aliases => aliases)
  end

  cron "awstats #{params[:name]}" do
    minute "*/10"
    command "/usr/lib/cgi-bin/awstats.pl -config=#{params[:name]} -update"
    user "root"
    mailto "notificacion.sistemas@aspgems.com"
  end

end
