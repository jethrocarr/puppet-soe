# Manage services
class soe::services {
  
  # Disable unwanted/bad services
  if ($::osfamily == "RedHat") {
    service { ['avahi-daemon']:
      ensure  => stopped,
    }
  }

  # Define core services to allow them to recieve notifications
  if ($::osfamily == "RedHat") {
    service { 'sshd':
      ensure => running,
    }

    if ($::operatingsystem != 'Fedora') {
      service { 'rsyslog':
        ensure => running,
      }
    }
  }

  if ($::osfamily == "Debian") {
    service { 'sshd':
      name   => 'ssh',
      ensure => running,
    }
    service { 'rsyslog':
      ensure => running,
    }
  }

}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
