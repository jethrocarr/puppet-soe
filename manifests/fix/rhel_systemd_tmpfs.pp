# Prevents RHEL from setting up /tmp as a tmpfs volume to work around a
# bug where the default (non-tmpfs) configuration is not respected.
#
# For more information, please refer to:
# https://www.jethrocarr.com/2016/02/18/tmp-mounted-as-tmpfs-on-centos/

class soe::fix::rhel_systemd_tmpfs (
  $enable = true,
) {

  if ($enable) {
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
}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
