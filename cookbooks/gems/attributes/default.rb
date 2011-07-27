set[:gems][:binary]="/usr/bin/gem"

if node.chef.attribute?("ree")
  if File.exists?(ree[:path]) && File.directory?(ree[:path]) # If rubyee is installed with britghtbox repository gem_binary is the same than with standard ruby
    set[:gems][:binary]=ree[:gem_path]
  end
end

case platform_version
when "8.04"
  dependencies=%w(libmagick9-dev libmysqlclient15-dev)
when "10.04"
  dependencies=%w(libmagickcore-dev libmysqlclient-dev libmagickwand-dev libmagickcore2 libmagickcore2-extra libmagickwand2)
end

set[:gems][:dependencies]=%w(libxslt1-dev libxml2 libxml2-dev imagemagick libfreeimage-dev) + dependencies
set[:gems][:packages]=%w(mysql newrelic_rpm bundler rake)

