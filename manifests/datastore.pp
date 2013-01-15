# == Class: openam::datastore
#
# Configuration of user and configuration stores for OpenAM
#
# === Authors
#
# Conduct AS <iam-nsb@conduct.no>
#
# === Copyright
#
# Copyright (c) 2013 Conduct AS
#

class openam::datastore {

  $common_opts = "-h ${opendj::host} -D '${opendj::admin_user}' -w ${opendj::admin_password}"
  $ldapsearch  = "${opendj::home}/bin/ldapsearch ${common_opts} -p ${opendj::ldap_port}"
  $ldapmodify  = "${opendj::home}/bin/ldapmodify ${common_opts} -p ${opendj::ldap_port}"
  $dsconfig    = "${opendj::home}/bin/dsconfig   ${common_opts} -p ${opendj::admin_port} -X -n"

  exec { "set single structural objectclass behavior":
    command => "${dsconfig} --advanced set-global-configuration-prop --set single-structural-objectclass-behavior:accept",
    unless  => "${dsconfig} --advanced get-global-configuration-prop | grep 'single-structural-objectclass-behavior : accept'",
  }

  exec { "create config backend":
    command => "${dsconfig} create-backend --backend-name amconfig --type local-db --set base-dn:${openam::configstore_suffix} --set enabled:true",
    unless  => "${dsconfig} list-backends | grep amconfig",
  }

  exec { "create users backend":
    command => "${dsconfig} create-backend --backend-name amusers --type local-db --set base-dn:${openam::userstore_suffix} --set enabled:true",
    unless  => "${dsconfig} list-backends | grep amusers",
  }

  file { "/var/tmp/am-configstore-suffix.ldif":
    ensure  => present,
    content => "dn: ${openam::configstore_suffix}\nobjectclass: top\nobjectclass: domain\ndc: config\n",
  }

  file { "/var/tmp/am-userstore-suffix.ldif":
    ensure  => present,
    content => "dn: ${openam::userstore_suffix}\nobjectclass: top\nobjectclass: domain\ndc: users\n",
  }

  exec { "create config suffix":
    command => "${ldapmodify} -a -f /var/tmp/am-configstore-suffix.ldif",
    unless  => "${ldapsearch} -s base -b ${openam::configstore_suffix} '(objectclass=*)' | grep ^dn",
    require => [ Exec["create config backend"], File["/var/tmp/am-configstore-suffix.ldif"] ],
  }

  exec { "create users suffix":
    command => "${ldapmodify} -a -f /var/tmp/am-userstore-suffix.ldif",
    unless  => "${ldapsearch} -s base -b ${openam::userstore_suffix} '(objectclass=*)' | grep ^dn",
    require => [ Exec["create users backend"], File["/var/tmp/am-userstore-suffix.ldif"] ],
  }
}
