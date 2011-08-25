#
# Cookbook Name:: oracle_instantclient
# Recipe:: rvm_passenger_wrapper
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

include_recipe "rvm::system_install"

root_path = node['oracle_instantclient']['rvm_passenger_wrapper']['root_path']
wrapper   = "#{root_path}/passenger_ruby"

# inject this wrapper script in place of default RVM wrapper in rvm_passenger
# recipe
node.set['rvm_passenger']['ruby_wrapper'] = wrapper

template wrapper do
  source    'passenger_ruby.erb'
  owner     'root'
  group     'rvm'
  mode      '0755'
end
