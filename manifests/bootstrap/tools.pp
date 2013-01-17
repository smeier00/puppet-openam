# == Class: openam::bootstrap::tools
#
# Deployment of ssoAdminTools.
#
# === Authors
#
# Conduct AS <iam-nsb@conduct.no>
#
# === Copyright
#
# Copyright (c) 2013 Conduct AS
#
class openam::bootstrap::tools (
  $ssoadm = hiera('openam_ssoadm', '/usr/local/bin/ssoadm'),
) {

  package { 'unzip': ensure => present }

  file { "${openam::config_dir}/cli":
    ensure    => directory,
    owner     => "${openam::tomcat_user}",
    group     => "${openam::tomcat_user}",
    mode      => 0755,
    require   => Exec["configure openam"],
  }

  file { "/var/tmp/ssoAdminTools_${openam::version}.zip":
    ensure => present,
    owner  => "${openam::tomcat_user}",
    group  => "${openam::tomcat_user}",
    source => "puppet:///${module_name}/ssoAdminTools_${openam::version}.zip",
  }

  exec { "deploy ssoadm":
    cwd     => '/var/tmp',
    creates => "${openam::config_dir}/cli/setup",
    require => [ Exec["configure openam"], File["${openam::config_dir}/cli"], Package['unzip'] ],
    command => "/usr/bin/unzip ssoAdminTools_${openam::version}.zip -d ${openam::config_dir}/cli/",
  }

  # FIXME: This is ugly.
  exec { "configure ssoadm":
    cwd         => "${openam::config_dir}/cli",
    creates     => "${openam::config_dir}/cli${openam::deployment_uri}",
    environment => "JAVA_HOME=${openam::java_home}",
    command     => "${openam::config_dir}/cli/setup -p ${openam::config_dir} -d ${openam::log_dir}/debug -l ${openam::log_dir}/logs",
    require     => Exec["deploy ssoadm"],
  }

  file { "${openam::config_dir}/.pass":
    ensure  => present,
    owner   => "${openam::tomcat_user}",
    group   => "${openam::tomcat_user}",
    mode    => 400,
    require => Exec["configure ssoadm"],
    content => "${openam::amadmin}\n",
  }

  file { "${ssoadm}":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 700,
    content => "#!/bin/bash\nexport JAVA_HOME=${openam::java_home}\ncommand=\$1\nshift;\n${openam::config_dir}/cli${openam::deployment_uri}/bin/ssoadm \$command -u amadmin -f ${openam::config_dir}/.pass \$@",
    require => File["${openam::config_dir}/.pass"],
  }
}
