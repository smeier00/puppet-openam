# == Class: openam
#
# Module for deployment and configuration of ForgeRock OpenAM with tools.
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

class openam(
  $version            = hiera('openam_version'),
  $build              = hiera('openam_build', ''),
  $master             = hiera('openam_master', undef),
  $java_home          = hiera('openam_java_home'),
  $tomcat_user        = hiera('ews_service_user'),
  $tomcat_home        = hiera('openam_tomcat_home'),
  $amadmin            = hiera('openam_amadmin'),
  $amldapuser         = hiera('openam_amldapuser'),
  $config_dir         = hiera('openam_config_dir'),
  $cookie_domain      = hiera('openam_cookie_domain'),
  $log_dir            = hiera('openam_log_dir'),
  $deployment_uri     = hiera('openam_deployment_uri'),
  $locale             = hiera('openam_locale'),
  $encryption_key     = hiera('openam_encryption_key'),
  $server_port        = hiera('openam_server_port'),
  $site_url           = hiera('openam_site_url'),
  $server_protocol    = hiera('openam_server_protocol'),

  $userstore_suffix   = hiera('openam_userstore_suffix'),
  $userstore_binddn   = hiera('openam_userstore_binddn'),
  $userstore_bindpw   = hiera('openam_userstore_bindpw'),
  $configstore_suffix = hiera('openam_configstore_suffix'),
  $configstore_binddn = hiera('openam_configstore_binddn'),
  $configstore_bindpw = hiera('openam_configstore_bindpw'),
) {
  

  include openam::tomcat
  include openam::deploy
  include openam::datastore
  include openam::config
  include openam::logs
  include openam::tools

  Class['opendj']            -> Class['openam::deploy']
  Class['openam::deploy']    -> Class['openam::datastore']
  Class['openam::datastore'] -> Class['openam::config']
  Class['openam::config']    -> Class['openam::logs']
  Class['openam::logs']      -> Class['openam::tools']
}
