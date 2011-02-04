packages= %w(apache2-prefork-dev libapr1-dev libaprutil1-dev zlib1g-dev build-essential)

packages.each do |p|
  package p do
    action :upgrade
  end
end

if node.platform == "ubuntu" && node.platform_version == "10.04"
  package "libcurl4-openssl-dev"
end
