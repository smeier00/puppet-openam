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

  file { "${openam::tomcat_home}/webapps${openam::deployment_uri}.war":
    ensure => present,
    owner  => "${openam::tomcat_user}",
    group  => "${openam::tomcat_user}",
    mode   => 0755,
    source => "puppet:///files/${module_name}/${environment}/${war}",
    notify => Service['tomcat-openam']
  }
}