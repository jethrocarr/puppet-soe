# Permit the wheel group password-less sudo
class soe::sudo {

  class { 'sudo':
    purge               => false,
    config_file_replace => false,
  }

  # TODO: is this FreeBSD compat?
  sudo::conf { 'admins':
    priority => 10,
    content  => "%wheel ALL=(ALL) NOPASSWD: ALL",
  }
}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
