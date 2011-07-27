repository "ppa:pratikmsinha/ruby192+bindings"

packages = %w(ruby1.9.2 ruby1.9.2-dev libreadline-ruby1.9.2 libopenssl-ruby1.9.2 irb1.9.2 rdoc1.9.2)
packages.each do |p|
  package p do
    action :upgrade
  end
end


