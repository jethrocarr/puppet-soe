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

    # TODO: is this FreeBSD compat?
    ::sudo::conf { 'admins':
      priority => 10,
      content  => "%wheel ALL=(ALL) NOPASSWD: ALL",
    }
  }
}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
