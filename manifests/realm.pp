define openam::realm {
  exec { "create subrealm $name":
    command => "${openam::tools::ssoadm} create-realm -e ${name}",
    unless  => "${openam::tools::ssoadm} list-realms -e / | grep ^${name}$",
  }
}
