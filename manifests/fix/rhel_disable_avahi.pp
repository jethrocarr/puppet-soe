# This dameon isn't wanted on a publically accessible webserver.

class soe::fix::rhel_disable_avahi (
  $enable = true,
) {

  if ($::osfamily == "RedHat") {
    service { ['avahi-daemon']:
      ensure => stopped,
    }
  }
}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
