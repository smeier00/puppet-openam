# == Class: openam::tools
#
# Module for deployment of ssoAdminTools.
#
# === Authors
#
# Conduct AS <iam-nsb@conduct.no>
#
# === Copyright
#
# Copyright (c) 2013 Conduct AS
#
class openam::tools {

  package { 'unzip': ensure => present }

  file { "${openam_config_dir}/cli":
    ensure    => directory,
    owner     => "${openam_tomcat_user}",
    group     => "${openam_tomcat_user}",
    mode      => 0755,
    require   => Exec["configure openam"],
  }

  file { "/var/tmp/ssoAdminTools_${openam_version}.zip":
    ensure => present,
    owner  => "${openam_tomcat_user}",
    group  => "${openam_tomcat_user}",
    source => "puppet:///${module_name}/ssoAdminTools_${openam_version}.zip",
  }

  exec { "deploy ssoadm":
    cwd     => '/var/tmp',
    creates => "${openam_config_dir}/cli/setup",
    require => [ Exec["configure openam"], File["${openam_config_dir}/cli"], Package['unzip'] ],
    command => "/usr/bin/unzip ssoAdminTools_${openam_version}.zip -d ${openam_config_dir}/cli/",
  }

  exec { "configure ssoadm":
    cwd         => "${openam_config_dir}/cli",
    creates     => "${openam_config_dir}/cli${openam_deployment_uri}",
    environment => "JAVA_HOME=${openam_java_home}",
    command     => "${openam_config_dir}/cli/setup -p ${openam_config_dir} -d ${openam_log_dir}/debug -l ${openam_log_dir}/logs",
    require     => Exec["deploy ssoadm"],
  }

  file { "${openam_config_dir}/.pass":
    ensure  => present,
    owner   => "${openam_tomcat_user}",
    group   => "${openam_tomcat_user}",
    mode    => 400,
    require => Exec["configure ssoadm"],
    content => "${openam_amadmin}\n",
  }

  file { "/usr/local/bin/ssoadm":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 700,
    content => "#!/bin/bash\nexport JAVA_HOME=${openam_java_home}\n${openam_config_dir}/cli${openam_deployment_uri}/bin/ssoadm \$1 -u amadmin -f ${openam_config_dir}/.pass \$2 \$3 \$4 \$5 \$6",
    require => File["${openam_config_dir}/.pass"],
  }
}
