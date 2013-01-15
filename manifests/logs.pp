# == Class: openam::logs
#
# Symlinks OpenAM log directories to a more suited location.
#
# === Authors
#
# Conduct AS <iam-nsb@conduct.no>
#
# === Copyright
#
# Copyright (c) 2013 Conduct AS
#
class openam::logs (
  $openam_tomcat_user    = hiera('openam_tomcat_user', $::ews_service_user),
  $openam_config_dir     = hiera('openam_config_dir', $::openam_config_dir),
  $openam_deployment_uri = hiera('openam_deployment_uri', $::openam_deployment_uri),
  $openam_log_dir        = hiera('openam_log_dir, $::openam_log_dir),
) {

  file { [ "${openam_log_dir}",
           "${openam_log_dir}/logs",
           "${openam_log_dir}/debug",
           "${openam_log_dir}/stats" ]:
    ensure  => directory,
    owner   => "${openam_tomcat_user}",
    group   => "${openam_tomcat_user}",
    mode    => 700,
  }

  # Symlink $OPENAM_CONFIG_HOME/$OPENAM_URI/{debug,logs,stats} to the
  # configured log directory, usually this would be /var/log/openam or
  # another directory on a partition with sufficient free disk space.

  file { "${openam_config_dir}${openam_deployment_uri}/logs":
    ensure    => link,
    target    => "${openam_log_dir}/logs",
    require   => File["${openam_log_dir}/logs"],
    force     => true,
  }

  file { "${openam_config_dir}${openam_deployment_uri}/debug":
    ensure    => link,
    target    => "${openam_log_dir}/debug",
    require   => File["${openam_log_dir}/debug"],
    force     => true,
  }

  file { "${openam_config_dir}${openam_deployment_uri}/stats":
    ensure    => link,
    target    => "${openam_log_dir}/stats",
    require   => File["${openam_log_dir}/stats"],
    force     => true,
  }
}
