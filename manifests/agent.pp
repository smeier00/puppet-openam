# == Class: openam::agent
#
# Management of OpenAM agent profiles.
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
  $type       = 'WebAgent',
  $ssoonly    = false,
  $logrotate  = false,
  $debuglevel = 'Error',
  $realm,
  $url,
) {
  $logout_urls        = [ "${openam::site_url}/UI/Logout?realm=${realm}" ]
  $login_urls         = [ "${openam::site_url}/UI/Login?realm=${realm}" ]
  $notification_url   = "${url}/UpdateAgentCacheServlet?shortcircuit=false"
  $cdcservlet_url     = "${openam::site_url}/cdcservlet"
  $agent_server_url   = "${openam::site_url}"
  $agent_profile_dir  = "${openam::config_dir}/.puppet/agents"
  $agent_profile_file = "${agent_profile_dir}/${type}_${title}.properties"

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
    command     => "${openam::tools::ssoadm} create-agent -e ${realm} -t ${type} -b ${name} -s ${agent_server_url} -g ${url} -D ${agent_profile_file}",
    onlyif      => "${openam::tools::ssoadm} list-agents -e ${realm} -t ${type} | grep ^'${name} '",
    refreshonly => true,
    notify      => Exec["create agent profile"],
  }
  
  exec { "create agent profile":
    command     => "${openam::tools::ssoadm} create-agent -e ${realm} -t ${type} -b ${name} -s ${agent_server_url} -g ${url} -D ${agent_profile_file}",
    unless      => "${openam::tools::ssoadm} list-agents -e ${realm} -t ${type} | grep ^'${name} '", 
    refreshonly => true,
  } 
}
