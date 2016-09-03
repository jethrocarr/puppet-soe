# Parent class

class soe (
  $manage_hostname                           = $soe::params::manage_hostname,
  $manage_swap_space                         = $soe::params::manage_swap_space,
  $manage_time_zone                          = $soe::params::manage_time_zone,
  $manage_time_ntp                           = $soe::params::manage_time_ntp,
  $manage_updates                            = $soe::params::manage_updates,
  $manage_updates_emailto                    = $soe::params::manage_updates_emailto,
  $enable_sudo_wheel                         = $soe::params::enable_sudo_wheel,
  $enable_newrelic                           = $soe::params::enable_newrelic,
  $disable_ssh_password                      = $soe::params::disable_ssh_password,
  $fix_rhel_systemd_tmpfs                    = $soe::params::fix_rhel_systemd_tmpfs,
  $fix_digital_ocean_disable_private_network = $soe::params::fix_digital_ocean_disable_private_network,

) inherits ::soe::params {

  # Include all desired base configuration

  if ($manage_hostname)       { require ::hostname }
  if ($manage_time_ntp)       { require ::ntp }
  if ($manage_updates)        { require ::soe::updates }
  if ($manage_swapspace)      { require ::soe::swapspace }

  if ($enable_sudo_wheel)     { require ::soe::sudo }
  if ($enable_newrelic)       { require ::newrelic::server::linux }
  if ($disable_ssh_password)  { require ::soe::sshnopassword }

  if ($manage_time_zone) {
    class { 'timezone':
      timezone => $manage_time_zone,
    }
  }


  # Include fixes

  if ($fix_rhel_systemd_tmpfs)                      { include ::soe::fix::rhel_systemd_tmpfs }
  if ($fix_digital_ocean_disable_private_network)   { include ::soe::fix::fix_digital_ocean_disable_private_network }

}
# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
