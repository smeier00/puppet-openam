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
class openam::agent (
  $realm = "/",
  $file,
  $type,
  $name,
) {
  $ssoadm = "/usr/local/bin/ssoadm"
  $agents = "${openam_conf_dir}/puppet/agents"
    
  file { "${agents}":
    ensure => directory,
    owner  => "${openam_tomcat_user}",
    mode   => 600,
  }

  file { "${agents}/${file}":
    ensure => present,
    source => "puppet:///agents/${file}",
  }

  exec { "create agent profile":
    command   => "${ssoadm} create-agent -e ${realm} -t ${type} -b ${name} -D ${file}",
    unless    => "${ssoadm} list-agents -e ${realm} -t ${type} | grep ^'${name} '", 
    subscribe => File["${file}"],
  } 

}
