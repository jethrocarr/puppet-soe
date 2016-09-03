# Disable eth1 from being managed by NetworkManager when running on a Digital
# Ocean box if private networking is disabled.
#
# We do this to stop NetworkManager from spamming syslog with repeatedly
# failing DHCP attempts for a network that isn't active.

class soe::fix::digital_ocean_disable_private_network {

  if ($::digital_ocean_id) {
    if (!$::digital_ocean_interfaces_private_0_ipv4_address) {
      # Server is on digital ocean AND there is no private IPv4 interface.

      if ($::osfamily == "RedHat") {
        # Drop in file disabling the interface from all management.
        file {'/etc/sysconfig/network-scripts/ifcfg-eth1':
          ensure => file,
          source => "puppet:///modules/soe/ifcfg-eth1",
        }
      }

      # TODO: Need digitial ocean int fix for other platforms here.
    }
  }

}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
