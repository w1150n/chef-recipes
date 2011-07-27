define :jruby_execute do

  execute "node[:jruby][:install_path]/bin/jruby -S #{params[:name]}" do
    not_if
  end

end
