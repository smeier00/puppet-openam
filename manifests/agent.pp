# == Define: openam::agent
#
# Define for management of OpenAM agent profiles.
#
# === Authors
#
# Conduct AS <iam-nsb@conduct.no>
#
# === Copyright
#
# Copyright (c) 2013 Conduct AS
#
define openam::agent (
  $type              = 'WebAgent',
  $ssoonly           = false,
  $logrotate         = false,
  $debuglevel        = 'Error',
  $protocol          = 'http',
  $port              = 80,
  $host,
  $logout_urls       = [ "${openam::site_url}/UI/Logout" ],
  $login_urls        = [ "${openam::site_url}/UI/Login" ],
  $notification_url  = "${protocol}://${host}:${port}/UpdateAgentCacheServlet?shortcircuit=false",
  $agent_logout_urls = [],
  $notenforced_ips   = [],
  $notenforced_urls  = [],
  $reset_cookies     = [],
  $properties        = {},
  $timeout           = 2,
  $password,
  $realm,
) {
  $agent_server_url   = "${openam::site_url}"
  $realm_real         = regsubst($realm, '^/', '')
  $realm_prefix       = regsubst($realm_real, '/', '_', 'G')
  $agent_url          = "${protocol}://${host}:${port}"
  $agent_profile_dir  = "${openam::config_dir}/.puppet/agents"
  $agent_profile_file = "${agent_profile_dir}/${realm_prefix}_${type}_${title}.properties"
  $password_hashed    = strip( template("${module_name}/agent_password.erb") )

  file { "${openam::config_dir}/.puppet":
    ensure => directory,
    owner  => "${openam::tomcat_user}",
    mode   => 0700,
  }
 
  file { "${agent_profile_dir}":
    ensure  => directory,
    owner   => "${openam::tomcat_user}",
    mode    => 600,
  }

  file { "${agent_profile_file}":
    ensure  => present,
    content => template("${module_name}/agent.properties.erb"),
    require => File["${agent_profile_dir}"],
    mode    => 0400,
    owner   => "${openam::tomcat_user}",
    group   => "${openam::tomcat_user}",
    notify  => Exec["update agent profile"],
  }

  exec { "update agent profile":
    command     => "${openam::bootstrap::tools::ssoadm} update-agent -e ${realm_real} -b ${name} -D ${agent_profile_file}",
    onlyif      => "${openam::bootstrap::tools::ssoadm} list-agents -e ${realm_real} -t ${type} | grep ^'${name} '",
    notify      => Exec["create agent profile"],
    refreshonly => true,
  }
  
  exec { "create agent profile":
    command     => "${openam::bootstrap::tools::ssoadm} create-agent -e ${realm_real} -t ${type} -b ${name} -s ${agent_server_url} -g ${agent_url} -D ${agent_profile_file}",
    unless      => "${openam::bootstrap::tools::ssoadm} list-agents -e ${realm_real} -t ${type} | grep ^'${name} '", 
    refreshonly => true,
  } 
}
