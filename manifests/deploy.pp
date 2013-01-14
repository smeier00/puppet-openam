# == Class: openam::deploy
#
# Module for deployment of ForgeRock OpenAM.
#
# === Examples
#
# === Authors
#
# Conduct AS <iam-nsb@conduct.no>
#
# === Copyright
#
# Copyright (c) 2013 Conduct AS
#

class openam::deploy (
  $openam_tomcat_user     = hiera('openam_tomcat_user', $::ews_service_user),
  $openam_tomcat_home     = hiera('openam_tomcat_home', $::openam_tomcat_home),
  $openam_version         = hiera('openam_version', $::openam_version),
  $openam_build           = hiera('openam_build', $::openam_build),
  $openam_deployment_uri  = hiera('openam_deployment_uri', $::openam_deployment_uri),
) {

  $openam_war = "openam_${openam_version}.war"
  file { "/var/tmp/${openam_war}":
    ensure => present,
    owner  => "${openam_tomcat_user}",
    group  => "${openam_tomcat_user}",
    mode   => 0755,
    source => "puppet:///modules/openam/${openam_war}",
  }

  exec { "deploy openam":
    cwd     => '/var/tmp',
    command => "/bin/cp /var/tmp/${openam_war} ${openam_tomcat_home}/webapps${openam_deployment_uri}.war",
    require => File["/var/tmp/${openam_war}"],
    creates => "${openam_tomcat_home}/webapps${openam_deployment_uri}",
  }
}
