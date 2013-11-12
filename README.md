# Puppet Module for ForgeRock OpenAM

`puppet-openam` deploys and configures your OpenAM servers with Puppet.

## Initial configuration

The module supports initial configuration of OpenAM through a POST
to `/config/configurator` from the included `configurator.pl` script.

    class { 'openam': }

The following parameters controls the initial configuration of OpenAM:

  * `version`: The OpenAM version number
  * `java_home`: Java home
  * `tomcat_user`: The POSIX user running Tomcat
  * `tomcat_home`: The home directory for Tomcat
  * `amadmin`: The OpenAM amadmin user password
  * `amldapuser`: The OpenAM amldapuser password (can't be the same as amadmin)
  * `deployment_uri`: The OpenAM deployment URI, e.g. `/sso`
  * `site_url`: The OpenAM site URL, e.g. `https://idp.example.com:443/sso`
  * `server_protocol`: The OpenAM server protocol, `http` or `https`
  * `cookie_domain`: The OpenAM cookie domain, e.g. `.example.com`
  * `config_dir`: The OpenAM configuration directory, e.g. `/opt/openam`
  * `log_dir`: The destination directory for OpenAM logs, e.g. `/var/log`
  * `locale`: The OpenAM locale, e.g. `en_US`
  * `ssoadm`: The path to install the ssoadm wrapper, default `/usr/local/bin/ssoadm`
  * `encryption_key`: The OpenAM encryption key
  * `userstore_binddn`: The LDAP user for the OpenAM user store, e.g. `cn=Directory Manager`
  * `userstore_bindpw`: The password for the user specified in `userstore_binddn`
  * `userstore_suffix`: The root suffix for the OpenAM user store
  * `configstore_binddn`: The LDAP user for the OpenAM configuration store, e.g. `cn=Directory Manager`
  * `configstore_bindpw`: The password for the user specified in `configstore_binddn`
  * `configstore_suffix`: The root suffix for the OpenAM configuration store
