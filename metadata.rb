maintainer       "Fletcher Nichol"
maintainer_email "fnichol@nichol.ca"
license          "Apache 2.0"
description      "Installs the Oracle OCI Instant Client from an internally trusted site"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.1"

recipe "oracle_instantclient", ""
recipe "oracle_instantclient::rvm_passenger_wrapper", ""

recommends "rvm",           "~> 0.8.0"
recommends "rvm_passenger"

supports "ubuntu"
supports "debian"
supports "suse"
supports "mac_os_x"
