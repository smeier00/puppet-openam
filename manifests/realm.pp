define openam::realm (
  $agents     = [],
  $modules    = [],
  $chains     = [],
  $datastores = [],
) {
  $name_real = regsubst($name, '^/', '')
  exec { "create subrealm ${name_real}":
    command => "${openam::tools::ssoadm} create-realm -e ${name_real}",
    unless  => "${openam::tools::ssoadm} list-realms -e / | grep ^${name_real}$",
  }
}
