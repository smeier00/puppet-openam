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

class openam::datastore (
  $opendj_admin_user         = hiera('opendj_admin_user', $::opendj_admin_user),
  $opendj_admin_password     = hiera('opendj_admin_password', $::opendj_admin_password),
  $openam_userstore_suffix   = hiera('openam_userstore_suffix', $::openam_userstore_suffix),
  $openam_configstore_suffix = hiera('openam_configstore_suffix', $::openam_configstore_suffix),
) {
  $opendj-home = '/var/lib/opendj'
  $common_opts = "-h ${opendj_host} -D '${opendj_admin_user}' -w ${opendj_admin_password}"
  $ldapsearch  = "${opendj_home}/bin/ldapsearch ${common_opts} -p ${opendj_ldap_port}"
  $ldapmodify  = "${opendj_home}/bin/ldapmodify ${common_opts} -p ${opendj_ldap_port}"
  $dsconfig    = "${opendj_home}/bin/dsconfig   ${common_opts} -p ${opendj_admin_port} -X -n"

  exec { "set single structural objectclass behavior":
    command => "${dsconfig} --advanced set-global-configuration-prop --set single-structural-objectclass-behavior:accept",
    unless  => "${dsconfig} --advanced get-global-configuration-prop | grep 'single-structural-objectclass-behavior : accept'",
  }

  exec { "create config backend":
    command => "${dsconfig} create-backend --backend-name amconfig --type local-db --set base-dn:${openam_configstore_suffix} --set enabled:true",
    unless  => "${dsconfig} list-backends | grep amconfig",
  }

  exec { "create users backend":
    command => "${dsconfig} create-backend --backend-name amusers --type local-db --set base-dn:${openam_userstore_suffix} --set enabled:true",
    unless  => "${dsconfig} list-backends | grep amusers",
  }

  file { "/var/tmp/am-configstore-suffix.ldif":
    ensure  => present,
    content => "dn: ${openam_configstore_suffix}\nobjectclass: top\nobjectclass: domain\ndc: config\n",
  }

  file { "/var/tmp/am-userstore-suffix.ldif":
    ensure  => present,
    content => "dn: ${openam_userstore_suffix}\nobjectclass: top\nobjectclass: domain\ndc: users\n",
  }

  exec { "create config suffix":
    command => "${ldapmodify} -a -f /var/tmp/am-configstore-suffix.ldif",
    unless  => "${ldapsearch} -s base -b ${openam_configstore_suffix} '(objectclass=*)' | grep ^dn",
    require => [ Exec["create config backend"], File["/var/tmp/am-configstore-suffix.ldif"] ],
  }

  exec { "create users suffix":
    command => "${ldapmodify} -a -f /var/tmp/am-userstore-suffix.ldif",
    unless  => "${ldapsearch} -s base -b ${openam_userstore_suffix} '(objectclass=*)' | grep ^dn",
    require => [ Exec["create users backend"], File["/var/tmp/am-userstore-suffix.ldif"] ],
  }
}
