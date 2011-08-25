#
# Cookbook Name:: oracle_instantclient
# Attributes:: default
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

default['oracle_instantclient']['basic_url']  = nil
default['oracle_instantclient']['sdk_url']    = nil

default['oracle_instantclient']['root_path']  = "/opt/oracle"

case kernel.name
when "Darwin"
  node.set['oracle_instantclient']['pkgs']          = []

  # As of 2011-08-25 only the 32-bit libs work on Lion:
  # http://only4left.jpiwowar.com/2011/08/instant-client-osx-lion-32-bit-only/
  if kernel.machine == "x86_64" && platform_version.split('.')[0,2].join('.').to_f <= 10.6
    basic_zip = "instantclient-basic-10.2.0.4.0-macosx-x64.zip"
    basic_sha = "ae0fc5b2148f58d4f3ed0f3d10fc2add50be33d1ac2f360fadb5be8eca28a4a7"
    sdk_zip   = "instantclient-sdk-10.2.0.4.0-macosx-x64.zip"
    sdk_sha   = "0373694ee8842cdc997616f1606091fe772c0799ad66757b2cfff73e3fae2b3d"
  else
    basic_zip = "instantclient-basic-10.2.0.4.0-macosx-x86.zip"
    basic_sha = "fdf84169bf5161c043dd805b74ac65f4e0d212a6af85fb41f862c8b5950b1ba0"
    sdk_zip   = "instantclient-sdk-10.2.0.4.0-macosx-x86.zip"
    sdk_sha   = "8d099b4f934e7d2bac7f182da4e2c4850501d18affeb0fde27d5ce2a9a4c6697"
  end
when "Linux"
  node.set['oracle_instantclient']['pkgs']          = %w{unzip}

  case kernel.machine
  when "x86_64"
    basic_zip = "instantclient-basic-linux-x86-64-11.2.0.2.0.zip"
    basic_sha = "eeaa8101138b59c73c22bbb25e2a1cfd415dc830cafba6f9f19696789ab666e2"
    sdk_zip   = "instantclient-sdk-10.2.0.4.0-macosx-x64.zip"
    sdk_sha   = "0373694ee8842cdc997616f1606091fe772c0799ad66757b2cfff73e3fae2b3d"
  else
    basic_zip = "instantclient-basic-linux32-11.2.0.2.0.zip"
    basic_sha = "53f97a73991b2380e987f7cf4e1ba650a866044892c378b9340dc2e695160c14"
    sdk_zip   = "instantclient-sdk-linux32-11.2.0.2.0.zip"
    sdk_sha   = "172c0116de16f55abd775aaf4dd1666d0e64eb1226b43388974ccf83235c8b18"
  end
end

default['oracle_instantclient']['basic_zip']  = basic_zip
default['oracle_instantclient']['basic_sha']  = basic_sha
default['oracle_instantclient']['sdk_zip']    = sdk_zip
default['oracle_instantclient']['sdk_sha']    = sdk_sha
