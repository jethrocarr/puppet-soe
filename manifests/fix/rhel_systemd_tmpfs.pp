# Prevents RHEL from setting up /tmp as a tmpfs volume by default despite the
# admin not-specifically opting in.

class soe::fix::rhel_systemd_tmpfs {

  if ($::osfamily == "RedHat") {
    if ($::initsystem == 'systemd') {
      exec { 'fix_tmpfs_systemd':
        path    => ['/bin', '/usr/bin'],
        command => 'systemctl mask tmp.mount',
        unless  => 'ls -l /etc/systemd/system/tmp.mount 2>&1 | grep -q "/dev/null"'
      }
    }
  }
}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
