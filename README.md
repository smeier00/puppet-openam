# Puppet Module for ForgeRock OpenAM

`puppet-openam` deploys and configures your OpenAM servers with Puppet.

## Initial configuration

The module supports initial configuration of OpenAM through a POST
to `/config/configurator` from the included `configurator.pl` script.

    class { 'openam': }

The following parameters controls the initial configuration of OpenAM:

  * `version`: The OpenAM version number
  * `build`: OpenAM build identifier (optional)
  * `amadmin`: The OpenAM amadmin user password
  * `amldapuser`: The OpenAM amldapuser password (can't be the same as amadmin)
  * `deployment_uri`: The OpenAM deployment URI, e.g. `/sso`
  * `site_url`: The OpenAM site URL, e.g. https://idp.example.com:443/sso
  * `server_protocol`: The OpenAM server protocol, `http` or `https`
  * `cookie_domain`: The OpenAM cookie domain, e.g. `.example.com`
  * `config_dir`: The OpenAM configuration directory, e.g. `/opt/openam`
  * `log_dir`: The destination directory for OpenAM logs, e.g. `/var/log`
  * `locale`: The OpenAM locale, e.g. `en_US`
  * `encryption_key`: The OpenAM encryption key
  * `userstore_binddn`: The LDAP user for the OpenAM user store, e.g. `cn=Directory Manager`
  * `userstore_bindpw`: The password for the user specified in `userstore_binddn`
  * `userstore_suffix`: The root suffix for the OpenAM user store
  * `configstore_binddn`: The LDAP user for the OpenAM configuration store, e.g. `cn=Directory Manager`
  * `configstore_bindpw`: The password for the user specified in `configstore_binddn`
  * `configstore_suffix`: The root suffix for the OpenAM configuration store

If not provided, parameters are looked up with `hiera()` prefixed with `openam_`,
e.g. `openam_version`. In addition, the following parameters from the `opendj`
module are used to determine the host and port settings during the initial setup:

  * `opendj::host`: IP or FQDN for the OpenDJ host (or VIP if loadbalanced)
  * `opendj::ldap_port`: The OpenDJ LDAP port, e.g. `1389`
  * `opendj::admin_user`: The OpenDJ admin user, e.g. `cn=Directory Manager`
  * `opendj::admin_password`: The OpenDJ admin password

## Managing configuration

A small subset of OpenAM configuration can be controlled with the following Puppet defines:

  * `openam::realm { $realm: }`: Add `$realm` to the OpenAM configuration
  * `openam::agent { $agent: realm => $realm, password => $password, type => $type, url => $url }`

