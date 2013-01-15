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
  $name = $title,
  $realm = '/',
  $type  = 'WebAgent',
  $agent_url = $url,
) {

  $logout_urls        = [ "${openam::site_url}/UI/Logout?realm=${realm}" ],
  $login_urls         = [ "${openam::site_url}/UI/Login?realm=${realm}" ],
  $server_url         = "${openam::site_url}",
  $agent_profile_dir  = "${openam::config_dir}/.puppet/agents"
  $agent_profile_file = "${agent_profile_dir}/${type}_${name}"
  $ssoadm             = "/usr/local/bin/ssoadm"

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
    content => template("${module_name}/agent_profile.erb"),
    require => File["${agent_profile_dir}"],
    mode    => 0400,
    owner   => "${openam::tomcat_user}",
    group   => "${openam::tomcat_user}",
    notify  => Exec["update agent profile"],
  }

  exec { "update agent profile":
    command     => "${ssoadm} create-agent -e ${realm} -t ${type} -b ${name} -s ${server_url} -g ${agent_url} -D ${agent_profile_file}",
    onlyif      => "${ssoadm} list-agents -e ${realm} -t ${type} | grep ^'${name} '",
    refreshonly => true,
    notify      => Exec["create agent profile"],
  }
  
  exec { "create agent profile":
    command     => "${ssoadm} create-agent -e ${realm} -t ${type} -b ${name} -s ${server_url} -g ${agent_url} -D ${agent_profile_file}",
    unless      => "${ssoadm} list-agents -e ${realm} -t ${type} | grep ^'${name} '", 
    refreshonly => true,
  } 
}
