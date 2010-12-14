define :rvm_ruby do

  include_recipe "git"

  remote_file "/home/#{params[:user]}/rvm-install-head" do
    source "http://rvm.beginrescueend.com/releases/rvm-install-head"
    owner params[:user]
    group params[:user]
    mode 0750
    not_if { File.directory?("/home/#{params[:user]}/.rvm/") }
  end

env= { "HOME" => "/home/#{params[:user]}","SHLVL"=>"1","SHELL" =>"/bin/bash" }

  execute "/home/#{params[:user]}/rvm-install-head" do
    user params[:user]
    group params[:user]
    environment env
    not_if { File.directory?("/home/#{params[:user]}/.rvm/") }
  end

  file "/home/#{params[:user]}/rvm-install-head" do
    action :delete
  end

  remote_file "/var/tmp/.add-rvm-to-profile-#{params[:user]}" do
    owner params[:user]
    group params[:user]
    source "add-to-profile"
    cookbook "rvm"
    not_if { File.exists?("/var/tmp/.rvm-configure-#{params[:user]}") }
  end

 # Hack around for appending text to this file without keeping it under chef
  execute "cat /var/tmp/.add-rvm-to-profile-#{params[:user]} >> /home/#{params[:user]}/.profile" do
    user params[:user]
    group params[:user]
    creates "/var/tmp/.rvm-configure-#{params[:user]}"
    environment env
  end

  file "/var/tmp/.rvm-configure-#{params[:user]}"

  packages = case params[:name]
  when /(\d\.\d\.\d(-head)?|ree)/
    %w(build-essential bison openssl libreadline5 libreadline5-dev curl git-core zlib1g zlib1g-dev libssl-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev autoconf)
  when "jruby"
    %w(curl sun-java6-bin sun-java6-jre sun-java6-jdk)
  when "ruby-head"
    %w(git-core subversion autoconf)
  when "ironruby"
    %w(curl mono-2.0-devel)
  end

  packages.map { |p| package p}

  env.store("PATH","/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/home/#{params[:user]}/.rvm/bin:/home/#{params[:user]}/.rvm/bin")
  execute "rvm install #{params[:name]}" do
    user params[:user]
     group params[:user]
    environment env
    creates "/var/tmp/.rvm-install-#{params[:user]}-#{params[:name]}"
  end

  execute "rvm #{params[:name]}" do
    user params[:user]
    group params[:user]
    environment env
    creates "/var/tmp/.rvm-install-#{params[:user]}-#{params[:name]}"
  end

  file "/var/tmp/.rvm-install-#{params[:user]}-#{params[:name]}"
end






