# == Class: openam::config
#
# Module for initial configuration of ForgeRock OpenAM.
#
# === Authors
#
# Eivind Mikkelsen <eivindm@conduct.no>
#
# === Copyright
#
# Copyright (c) 2013 Conduct AS
#

class openam::config {
  $server_url = "${openam::server_protocol}://${fqdn}:${openam::server_port}"
 
  package { "perl-Crypt-SSLeay": ensure => installed }
  package { "perl-libwww-perl": ensure => installed }
  
  file { "${openam::tomcat_home}/.openamcfg":
    ensure => directory,
    owner  => "${openam::tomcat_user}",
    group  => "${openam::tomcat_user}",
    mode   => 755,
  }
 
  # Contains passwords, thus (temporarily) stored in /dev/shm
  file { "/dev/shm/configurator.properties":
    owner   => root,
    group   => root,
    mode    => 600,
    content => template("${module_name}/configurator.properties.erb"),
  }

  file { "/dev/shm/configurator.pl":
    owner   => root,
    group   => root,
    mode    => 700,
    require => File["/dev/shm/configurator.properties"], 
    source  => "puppet:///modules/${module_name}/configurator.pl",
  }

  file { "${openam::config_dir}":
    ensure => directory,
    owner  => "${openam::tomcat_user}",
    group  => "${openam::tomcat_user}",
  }

  exec { "configure openam":
    command => "/dev/shm/configurator.pl -f /dev/shm/configurator.properties",
    require => [
      File["/dev/shm/configurator.pl"],
      File["${openam::config_dir}"],
      Package["perl-Crypt-SSLeay"],
      Package["perl-libwww-perl"]
    ],
    creates => "${openam::config_dir}/bootstrap",
    notify => [ 
      Service["tomcat-openam"],
      Exec['wait_for_tomcat'],
    ]
  }
}
