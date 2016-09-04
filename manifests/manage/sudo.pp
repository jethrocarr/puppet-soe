# Setup sudo to permit root access for any users in the `wheel` group without
# requiring a password.

class soe::manage::sudo (
  $enable = true,
  ) {

  if ($enable) {

    class { '::sudo':
      purge               => false,
      config_file_replace => false,
    }

    ::sudo::conf { 'admins':
      priority => 10,
      content  => "%wheel ALL=(ALL) NOPASSWD: ALL",
    }

    if ($::osfamily == 'Debian') {
      # Debian systems don't have a wheel group created by default, but we want
      # one in order to make our sudo rules functional. As this group is in the
      # SOE module, it will be created before any other users outside of SOE,
      # making it easy to rely on as a dependency.

      group { 'wheel':
        ensure => present,
        system => true,
      }
    }
  }
}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
