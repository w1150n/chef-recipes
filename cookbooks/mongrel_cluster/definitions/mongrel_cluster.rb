define :mongrel_cluster do
  include_recipe "mongrel_cluster"

  service "mongrel_cluster_#{params[:name]}" do
    start_command "mongrel_rails cluster::start -C #{params[:path]}/shared/config/mongrel_cluster.yml --clean"
    stop_command  "mongrel_rails cluster::stop -C #{params[:path]}/shared/config/mongrel_cluster.yml --clean"
    restart_command "mongrel_rails cluster::restart -C #{params[:path]}/shared/config/mongrel_cluster.yml --clean"
    action :nothing
    pattern "mongrel_rails"
  end

  template "#{params[:path]}/shared/config/mongrel_cluster.yml" do
    mode "0644"
    owner params[:user]
    group params[:group]
    source "mongrel_cluster.yml.erb"
    cookbook "mongrel_cluster"
    variables(
              :name     => params[:name],
              :mongrels => params[:mongrels],
              :path => params[:path],
              :port => params[:port],
              :user => params[:user],
              :group => params[:group] )
    notifies :restart, resources(:service =>"mongrel_cluster_#{params[:name]}")
  end

  include_recipe "monit::default"

  template "/etc/monit/conf.d/mongrel-cluster-#{params[:name]}.monitrc" do
    mode "0644"
    owner params[:user]
    group params[:group]
    source "mongrel_cluster.monitrc.erb"
    cookbook "mongrel_cluster"
    variables(
              :mongrels => params[:mongrels],
              :path => params[:path] ,
              :port => params[:port],
              :name => params[:name],
              :mongrel_start_timeout => params[:mongrel_start_timeout],
              :memory_limit => params[:memory_limit]
              )
    notifies :restart, resources(:service => "monit")
  end
end
