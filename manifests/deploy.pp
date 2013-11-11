# == Class: openam::deploy
#
# Module for deployment of ForgeRock OpenAM.
#
# === Authors
#
# Eivind Mikkelsen <eivindm@conduct.no>
#
# === Copyright
#
# Copyright (c) 2013 Conduct AS
#

class openam::deploy {
  $war = "openam_${openam::version}.war"

  file { "/var/tmp/${war}":
    ensure => present,
    owner  => "${openam::tomcat_user}",
    group  => "${openam::tomcat_user}",
    mode   => 0755,
    source => "puppet:///files/${module_name}/${war}",
  }

  exec { "deploy openam":
    cwd     => '/var/tmp',
    command => "/bin/cp /var/tmp/${war} ${openam::tomcat_home}/webapps${openam::deployment_uri}.war",
    require => File["/var/tmp/${war}"],
    creates => "${openam::tomcat_home}/webapps${openam::deployment_uri}",
  }
}
