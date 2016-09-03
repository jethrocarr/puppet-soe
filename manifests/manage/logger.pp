# Define logging configuration.

class soe::manage::logger (
  $enable               = true,
  ) {

  if ($enable) {
    # We need to define the rsyslog service so that we can send it restarts
    # / notifications in future.

    if ($::osfamily == "RedHat") {
      if ($::operatingsystem != 'Fedora') {
        # TODO: why did we ignore Fedora?
        service { 'rsyslog':
          ensure => running,
        }
      }
    }
    if ($::osfamily == "Debian") {
      service { 'rsyslog':
        ensure => running,
      }
    }
  }
}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
