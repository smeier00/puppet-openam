# Temporary class for Tomcat, to be replaced by EWS module

class openam::tomcat {
  service { 'tomcat6':
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus => true,
  }
}
