# == Define: openam::realm
#
# Define for management of OpenAM agent profiles.
#
# === Authors
#
# Conduct AS <si@conduct.no>
#
# === Copyright
#
# Copyright (c) 2013 Conduct AS
#
define openam::realm {

  $name_real = regsubst($name, '^/', '')
  $ssoadm    = "${openam::bootstrap::tools::ssoadm}"

  exec { "create subrealm ${name_real}":
    command => "${ssoadm} create-realm -e ${name_real}",
    unless  => "${ssoadm} list-realms -e / | grep ^${name_real}$",
  }
}
