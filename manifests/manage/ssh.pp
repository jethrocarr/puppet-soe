# Setup SSH with some secure defaults and define the service.

class soe::manage::ssh (
  $enable               = true,
  $enable_password_auth = false,
  ) {

  if ($enable) {

    # Define the SSH service so we can perform actions against it elsewhere in SOE
    # and other modules.
    if ($::osfamily == "RedHat") {
      service { 'sshd':
        ensure => running,
      }
    }

    if ($::osfamily == "Debian") {
      service { 'sshd':
        name   => 'ssh',
        ensure => running,
      }
    }

    # Disable password-based authentication by default. You should really, really
    # not change this, keys are the only way to have a secure server with SSH on
    # the public web.
    #
    # Note: as a general rule, not in favour of doing Augeas, but this is one
    # of the few times that it works a lot more nicely than replacing the whole
    # configuration file with a Puppet managed one.
    if ($enable_password_auth == false) {
      augeas { "sshd_config":
        notify  => Service['sshd'],
        changes => [
          "set /files/etc/ssh/sshd_config/PasswordAuthentication no",
          "set /files/etc/ssh/sshd_config/GSSAPIAuthentication no",
        ],
      }
    }

  }
}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
