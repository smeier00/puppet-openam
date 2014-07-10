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
  $master             = hiera('openam::master', undef),
  $java_home          = hiera('openam::java_home'),
  $tomcat_user        = hiera('openam::tomcat_user'),
  $tomcat_home        = hiera('openam::tomcat_home'),
  $amadmin            = hiera('openam::amadmin'),
  $amldapuser         = hiera('openam::amldapuser'),
  $config_dir         = hiera('openam::config_dir', '/opt/openam'),
  $cookie_domain      = hiera('openam::cookie_domain'),
  $log_dir            = hiera('openam::log_dir', '/var/log'),
  $deployment_uri     = hiera('openam::deployment_uri'),
  $locale             = hiera('openam::locale', 'en_US'),
  $encryption_key     = hiera('openam::encryption_key'),
  $server_port        = hiera('openam::server_port', '8080'),
  $site_url           = hiera('openam::site_url'),
  $server_protocol    = hiera('openam::server_protocol', 'http'),
  $ssoadm             = hiera('openam::ssoadm', '/usr/local/bin/ssoadm'),

  $userstore_host         = hiera('openam::userstore_host', $fqdn),
  $userstore_ldap_port    = hiera('openam::userstore_ldap_port', '1389'),
  $userstore_suffix       = hiera('openam::userstore_suffix'),
  $userstore_binddn       = hiera('openam::userstore_binddn'),
  $userstore_bindpw       = hiera('openam::userstore_bindpw'),
  $configstore_host       = hiera('openam::configstore_host', $fqdn),
  $configstore_ldap_port  = hiera('openam::configstore_ldap_port', '1389'),
  $configstore_admin_port = hiera('openam::configstore_admin_port', '4444'),
  $configstore_jmx_port   = hiera('openam::configstore_jmx_port', '1689'),
  $configstore_suffix     = hiera('openam::configstore_suffix'),
  $configstore_binddn     = hiera('openam::configstore_binddn'),
  $configstore_bindpw     = hiera('openam::configstore_bindpw'),

) {

  include openam::deploy
  include openam::config
  include openam::logs
  include openam::tools

  Class['opendj']            -> Class['openam::deploy']
  Class['openam::deploy']    -> Class['openam::config']
  Class['openam::config']    -> Class['openam::logs']
  Class['openam::logs']      -> Class['openam::tools']
}
