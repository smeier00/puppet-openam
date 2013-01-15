class openam::config {
  $server_url = "${openam::server_protocol}://${fqdn}:${openam::server_port}"
  
  file { "${openam::tomcat_home}/.openssocfg":
    ensure => directory,
    owner  => "${openam::tomcat_user}",
    group  => "${openam::tomcat_user}",
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

  file { "${config_dir}":
    ensure => directory,
    owner  => "${openam::tomcat_user}",
    group  => "${openam::tomcat_user}",
  }

  exec { "configure openam":
    command => "${openam::java_home}/bin/java -jar /dev/shm/configurator.jar -f /dev/shm/configurator.properties",
    require => [ File["/dev/shm/configurator.jar"], File["${openam::config_dir}"] ],
    creates => "${openam::config_dir}/bootstrap",
    notify => Service["tomcat6"],
  }
}
