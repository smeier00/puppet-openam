class openam::config (

  # OpenAM server and site configuration
  $openam_java_home       = hiera('openam_java_home', $::openam_java_home),
  $openam_tomcat_user     = hiera('openam_tomcat_user', $::ews_service_user),
  $openam_tomcat_home     = hiera('openam_tomcat_home', $::openam_tomcat_home),
  $openam_version         = hiera('openam_version', $::openam_version),
  $openam_build           = hiera('openam_build', $::openam_build),
  $openam_amadmin         = hiera('openam_amadmin', $::openam_amadmin),
  $openam_amldapuser      = hiera('openam_amldapuser', $::openam_amldapuser),
  $openam_config_dir      = hiera('openam_config_dir', $::openam_config_dir),
  $openam_cookie_domain   = hiera('openam_cookie_domain', $::openam_cookie_domain),
  $openam_log_dir         = hiera('openam_log_dir', $::openam_log_dir),
  $openam_deployment_uri  = hiera('openam_deployment_uri', $::openam_deployment_uri),
  $openam_locale          = hiera('openam_locale', $::openam_locale),
  $openam_encryption_key  = hiera('openam_encryption_key', $::openam_encryption_key),
  $openam_server_port     = hiera('openam_server_port', $::openam_server_port),
  $openam_site_url        = hiera('openam_site_url', $::openam_site_url),
  $openam_server_protocol = hiera('openam_server_protocol', $::openam_server_protocol),
  $openam_server_url      = "${openam_server_protocol}://${fqdn}:${openam_server_port}",
  $openam_war             = "openam_${openam_version}.war",

  $openam_userstore_suffix   = hiera('openam_userstore_suffix', $::openam_userstore_suffix),
  $openam_userstore_binddn   = hiera('openam_userstore_binddn', $::openam_userstore_binddn),
  $openam_userstore_bindpw   = hiera('openam_userstore_bindpw', $::openam_userstore_bindpw),
  $openam_configstore_suffix = hiera('openam_configstore_suffix', $::openam_configstore_suffix),
  $openam_configstore_binddn = hiera('openam_configstore_binddn', $::openam_configstore_binddn),
  $openam_configstore_bindpw = hiera('openam_configstore_bindpw', $::openam_configstore_bindpw),
) {

  file { "${openam_tomcat_home}/.openssocfg":
    ensure => directory,
    owner  => "${openam_tomcat_user}",
    group  => "${openam_tomcat_user}",
    mode   => 755,
  }
 
  # Contains passwords, thus (temporarily) stored in /dev/shm
  file { "/dev/shm/configurator.properties":
    owner   => root,
    group   => root,
    mode    => 600,
    content => template("${module_name}/configurator.properties.erb"),
  }

  file { "/dev/shm/configurator.jar":
    owner   => root,
    group   => root,
    mode    => 700,
    require => File["/dev/shm/configurator.properties"], 
    source  => "puppet:///modules/openam/configurator.jar",
  }

  file { "${openam_config_dir}":
    ensure => directory,
    owner  => "${openam_tomcat_user}",
    group  => "${openam_tomcat_user}",
  }

  exec { "configure openam":
    command => "${openam_java_home}/bin/java -jar /dev/shm/configurator.jar -f /dev/shm/configurator.properties",
    require => [ File["/dev/shm/configurator.jar"], File["${openam_config_dir}"] ],
    creates => "${openam_config_dir}/bootstrap",
  }
}
