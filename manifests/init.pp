# == Class: openam
#
# Module for deployment and configuration of ForgeRock OpenAM with tools.
#
# === Authors
#
# Eivind Mikkelsen <eivindm@conduct.no>
#
# === Copyright
#
# Copyright (c) 2013 Conduct AS
#

class openam(
  $version            = hiera('openam::version'),
  $build              = hiera('openam::build', ''),
  $master             = hiera('openam::master', undef),
  $java_home          = hiera('openam::java_home'),
  $tomcat_user        = hiera('openam::tomcat_user'),
  $tomcat_home        = hiera('openam::tomcat_home'),
  $amadmin            = hiera('openam::amadmin'),
  $amldapuser         = hiera('openam::amldapuser'),
  $config_dir         = hiera('openam::config_dir'),
  $cookie_domain      = hiera('openam::cookie_domain'),
  $log_dir            = hiera('openam::log_dir'),
  $deployment_uri     = hiera('openam::deployment_uri'),
  $locale             = hiera('openam::locale'),
  $encryption_key     = hiera('openam::encryption_key'),
  $server_port        = hiera('openam::server_port'),
  $site_url           = hiera('openam::site_url'),
  $server_protocol    = hiera('openam::server_protocol'),
  $ssoadm             = hiera('openam::ssoadm', '/usr/local/bin/ssoadm'),

  $userstore_suffix   = hiera('openam::userstore_suffix'),
  $userstore_binddn   = hiera('openam::userstore_binddn'),
  $userstore_bindpw   = hiera('openam::userstore_bindpw'),
  $configstore_suffix = hiera('openam::configstore_suffix'),
  $configstore_binddn = hiera('openam::configstore_binddn'),
  $configstore_bindpw = hiera('openam::configstore_bindpw'),
  $ldap_host          = hiera('opendj::host'),

) {

  include openam::deploy
  include openam::config
  include openam::logs
  include openam::tools

  Class['opendj'] 	     -> Class['openam::deploy']
  Class['openam::deploy']    -> Class['openam::config']
  Class['openam::config']    -> Class['openam::logs']
  Class['openam::logs']      -> Class['openam::tools']
}
