# -*- coding: utf-8 -*-
#
# Cookbook Name:: ruby
# Recipe:: ruby-1.8.7
#
# Copyright 2009, Jacobo García López de Araujo.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# We need to remove ruby enterprise repository
# if previously exists in order to install regular ruby

include_recipe "chef::client"

reboot_chef = false

if RUBY_DESCRIPTION=~/(.*) Ruby Enterprise Edition/

  reboot_chef = true
  remove_repository "brightbox-rubyee.list"
  add_apt_preferences "ruby1.8" do
    packages %w(libopenssl-ruby1.8 libreadline-ruby1.8 libruby1.8 ruby1.8 ruby1.8-dev)
    pin "release l=Ubuntu"
    pin_priority "600"
  end
end

packages = %w(libopenssl-ruby1.8 libreadline-ruby1.8 libruby1.8 ruby1.8 ruby1.8-dev)

#packages = %w(ruby ruby-dev libopenssl-ruby libreadline-ruby librmagick-ruby librmagick-ruby1.8 ruby1.8 ruby1.8-dev libopenssl-ruby1.8 librmagick-ruby1.8 libruby1.8 libreadline-ruby1.8)

packages.each do |p|
  package p do
    action :upgrade
    options "--force-yes"
    notifies :restart, resources(:service => "chef-client") if reboot_chef
  end
end

