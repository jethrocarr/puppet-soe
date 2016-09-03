# Configure SSH to only permit key-based authentication.
class soe::sshnopassword {

  # Note: as a general rule, not in favour of doing Augeas, but this is one
  # of the few times that it works a lot more nicely than replacing the whole
  # configuration file with a Puppet managed one.
  augeas { "sshd_config":
    notify  => Service['sshd'],
    changes => [
      "set /files/etc/ssh/sshd_config/PasswordAuthentication no",
      "set /files/etc/ssh/sshd_config/GSSAPIAuthentication no",
    ],
  }
}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
