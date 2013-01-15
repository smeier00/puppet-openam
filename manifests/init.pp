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
  $openam_master             = hiera('openam_master, $::openam_master),
  $openam_java_home          = hiera('openam_java_home', $::openam_java_home),
  $openam_tomcat_user        = hiera('openam_tomcat_user', $::ews_service_user),
  $openam_tomcat_home        = hiera('openam_tomcat_home', $::openam_tomcat_home),
  $openam_version            = hiera('openam_version', $::openam_version),
  $openam_build              = hiera('openam_build', $::openam_build),
  $openam_amadmin            = hiera('openam_amadmin', $::openam_amadmin),
  $openam_amldapuser         = hiera('openam_amldapuser', $::openam_amldapuser),
  $openam_config_dir         = hiera('openam_config_dir', $::openam_config_dir),
  $openam_cookie_domain      = hiera('openam_cookie_domain', $::openam_cookie_domain),
  $openam_log_dir            = hiera('openam_log_dir', $::openam_log_dir),
  $openam_deployment_uri     = hiera('openam_deployment_uri', $::openam_deployment_uri),
  $openam_locale             = hiera('openam_locale', $::openam_locale),
  $openam_encryption_key     = hiera('openam_encryption_key', $::openam_encryption_key),
  $openam_server_port        = hiera('openam_server_port', $::openam_server_port),
  $openam_site_url           = hiera('openam_site_url', $::openam_site_url),
  $openam_server_protocol    = hiera('openam_server_protocol', $::openam_server_protocol),

  $openam_userstore_suffix   = hiera('openam_userstore_suffix', $::openam_userstore_suffix),
  $openam_userstore_binddn   = hiera('openam_userstore_binddn', $::openam_userstore_binddn),
  $openam_userstore_bindpw   = hiera('openam_userstore_bindpw', $::openam_userstore_bindpw),
  $openam_configstore_suffix = hiera('openam_configstore_suffix', $::openam_configstore_suffix),
  $openam_configstore_binddn = hiera('openam_configstore_binddn', $::openam_configstore_binddn),
  $openam_configstore_bindpw = hiera('openam_configstore_bindpw', $::openam_configstore_bindpw),
) {
  
  $openam_server_url = "${openam_server_protocol}://${fqdn}:${openam_server_port}"
  $openam_war        = "openam_${openam_version}.war"

  include opendj
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
