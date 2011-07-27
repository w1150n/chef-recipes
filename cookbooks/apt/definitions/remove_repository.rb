define :remove_repository do

  include_recipe "apt::default"

  file "/etc/apt/sources.list.d/#{params[:name]}" do
    action :delete
    notifies :run, resources(:execute => "apt-get update"), :immediately
  end
end
