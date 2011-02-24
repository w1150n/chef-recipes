# -*- coding: utf-8 -*-
maintainer       "Jacobo García"
maintainer_email "jacobo.garcia@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures ruby"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.3"

%w{ ubuntu }.each do |os|
  supports os
end

depends 'apt'
depends 'restart'
depends 'chef'
