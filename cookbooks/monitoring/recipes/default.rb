# -*- coding: undecided -*-
#
# Cookbook Name:: monitoring
# Recipe:: default
#
# Copyright 2009, Jacobo García López de Araujo
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

package "monit" do
  action :upgrade
end

directory "/etc/monit/conf.d" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

cookbook_file "/etc/monit/monitrc" do
  source "monitrc"
  mode "0600"
  owner "root"
  group "root"
  notifies :restart, resources(:service => "monit")
end

cookbook_file "/etc/default/monit" do
source "monit"
  mode "0644"
  owner "root"
  group "root"
  notifies :reload, resources(:service => "monit")
end

service "monit" do
  supports :restart => true, :reload => true
  reload_command "monit reload"
  action :nothing
end


monit_files = %w{ disk-space email-alerts general }

monit_files.each do |f|
  cookbook_file "/etc/monit/conf.d/#{f}.monitrc" do
    source f
    mode "0644"
    owner "root"
    group "root"
    notifies :reload, resources(:service => "monit")
  end
end


