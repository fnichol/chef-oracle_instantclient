#
# Cookbook Name:: oracle_instantclient
# Recipe:: default
#
# Copyright 2011, Fletcher Nichol
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

unless node[:oracle_instantclient][:basic_url]
  abort "You must set `oracle_instantclient/basic_url' with the URL to download the zipfile."
end
unless node[:oracle_instantclient][:sdk_url]
  abort "You must set `oracle_instantclient/sdk_url' with the URL to download the zipfile."
end

opts        = node[:oracle_instantclient]
cache_path  = Chef::Config[:file_cache_path]
root_path   = opts[:root_path]
basic_zip   = opts[:basic_url].split("/").last
sdk_zip     = opts[:sdk_url].split("/").last

package "unzip"

remote_file "#{cache_path}/#{basic_zip}" do
  source    opts[:basic_url]
  mode      "0644"
end

remote_file "#{cache_path}/#{sdk_zip}" do
  source    opts[:sdk_url]
  mode      "0644"
end

directory opts[:root_path] do
  recursive true
  mode      "0755"
end

bash "extract #{basic_zip}" do
  cwd       cache_path
  code      %{unzip #{cache_path}/#{basic_zip} -d #{root_path}}
  not_if    %{test -f #{root_path}/instantclient_*/BASIC_README}
end

bash "extract #{sdk_zip}" do
  cwd       cache_path
  code      %{unzip #{cache_path}/#{sdk_zip} -d #{root_path}}
  not_if    %{test -f #{root_path}/instantclient_*/sdk/SDK_README}
end

bash "fix broken symlink" do
  cwd       root_path
  code      <<-FIX
    cd instantclient_*
    so_file=$(ls -1 libclntsh.so.*)
    ln -sf ./$so_file libclntsh.so
  FIX
  not_if    %{test -h libclntsh.so}
end

template "/etc/profile.d/instantclient.sh" do
  source    "instantclient.sh.erb"
  owner     "root"
  group     "root"
  mode      "0644"
end
