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

if node['oracle_instantclient']['basic_url'].nil?
  Chef::Log.warn("recipe[oracle_instantclient]: You must set " +
    "node['oracle_instantclient']['basic_url'] with the URL to download " +
    "the zipfile.")
end
if node['oracle_instantclient']['sdk_url'].nil?
  Chef::Log.warn("recipe[oracle_instantclient]: You must set " +
    "node['oracle_instantclient']['sdk_url'] with the URL to download " +
    "the zipfile.")
end

cache_path  = Chef::Config[:file_cache_path]
root_path   = node['oracle_instantclient']['root_path']
basic_url   = node['oracle_instantclient']['basic_url']
basic_zip   = node['oracle_instantclient']['basic_zip']
basic_sha   = node['oracle_instantclient']['basic_sha']
sdk_url     = node['oracle_instantclient']['sdk_url']
sdk_zip     = node['oracle_instantclient']['sdk_zip']
sdk_sha     = node['oracle_instantclient']['sdk_sha']

Array(node['oracle_instantclient']['pkgs']).each do |pkg|
  package pkg
end

remote_file "#{cache_path}/#{basic_zip}" do
  source    basic_url || "http://no-url-set.example.com"
  checksum  basic_sha if basic_sha
  mode      '0644'
end

remote_file "#{cache_path}/#{sdk_zip}" do
  source    sdk_url || "http://no-url-set.example.com"
  checksum  sdk_sha if sdk_sha
  mode      '0644'
end

directory root_path do
  recursive true
  mode      '0755'
end

execute "Extract #{basic_zip}" do
  cwd       cache_path
  command   %{unzip #{cache_path}/#{basic_zip} -d #{root_path}}

  not_if    %{test -f #{root_path}/instantclient_*/BASIC_README}
end

execute "Extract #{sdk_zip}" do
  cwd       cache_path
  command   %{unzip #{cache_path}/#{sdk_zip} -d #{root_path}}

  not_if    %{test -f #{root_path}/instantclient_*/sdk/SDK_README}
end

case node['kernel']['name']
when "Darwin"
  execute "Fix broken symlink" do
    cwd       root_path
    command   <<-FIX
      cd instantclient_*
      dylib_file=$(ls -1 libclntsh.dylib.*)
      ln -sf ./$dylib_file libclntsh.dylib
    FIX

    not_if    %{test -h #{root_path}/instantclient_*/libclntsh.dylib}
  end
else
  execute "Fix broken symlink" do
    cwd       root_path
    command   <<-FIX
      cd instantclient_*
      so_file=$(ls -1 libclntsh.so.*)
      ln -sf ./$so_file libclntsh.so
    FIX

    not_if    %{test -h #{root_path}/instantclient_*/libclntsh.so}
  end
end

directory "/etc/profile.d"

template "/etc/profile.d/instantclient.sh" do
  source    'instantclient.sh.erb'
  mode      '0644'
end

if node['platform'] == "ubuntu"
  template "/etc/ld.so.conf.d/instantclient.conf" do
    source  'ld.so.conf.erb'
    mode    '0644'
  end

  execute "ldconfig"
end
