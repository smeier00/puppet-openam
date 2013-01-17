class openam::bootstrap {
  include openam::bootstrap::deploy
  include openam::bootstrap::datastore
  include openam::bootstrap::configure
  include openam::bootstrap::logs
  include openam::bootstrap::tools

  Class['openam::bootstrap::deploy']    -> Class['openam::bootstrap::datastore']
  Class['openam::bootstrap::datastore'] -> Class['openam::bootstrap::configure']
  Class['openam::bootstrap::configure'] -> Class['openam::bootstrap::logs']
  Class['openam::bootstrap::logs']      -> Class['openam::bootstrap::tools']
}
