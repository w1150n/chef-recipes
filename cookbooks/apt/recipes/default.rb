#
# Cookbook Name:: apt
# Recipe:: default
#
# Copyright 2010, Jacobo Garcia
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

apt_get_update = execute "apt-get update" do
  action :nothing
end

package "python-software-properties" do
  action :upgrade
end

template "/etc/apt/preferences" do
  source "preferences.erb"
  mode "0644"
  cookbook "apt"
  notifies :run, resources(:execute => "apt-get update"), :immediately
end
