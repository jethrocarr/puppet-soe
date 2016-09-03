# This init class links together all the components of the SOE module. The
# syntax/style of this file is annoying, since it has to differ from most
# puppet modules.
#
# Instead of breaking the module into various sub classes or definitions that
# can be included as needed like we would with most normal modules, the SOE
# needs to be a single includable class that we can call and then use Hiera
# to vary any of it's configuration.
#
# Hence this file is a pretty ugly read. :-(
#
# On the plus side all these configuration params *are* defined - please read
# the `manifests/params.pp` file to find out much more about all the options
# below.

class soe (
  $manage_hostname                           = $soe::params::manage_hostname,
  $manage_services                           = $soe::params::manage_services,
  $manage_swap_space                         = $soe::params::manage_swap_space,
  $manage_time_zone                          = $soe::params::manage_time_zone,
  $manage_time_ntp                           = $soe::params::manage_time_ntp,
  $manage_updates                            = $soe::params::manage_updates,
  $manage_updates_emailto                    = $soe::params::manage_updates_emailto,
  $enable_sudo_wheel                         = $soe::params::enable_sudo_wheel,
  $enable_newrelic                           = $soe::params::enable_newrelic,
  $enable_repo_jethrocarr                    = $soe::params::enable_repo_jethrocarr,
  $enable_repo_epel                          = $soe::params::enable_repo_epel,
  $packages_ensure                           = $soe::params::packages_ensure,
  $disable_ssh_password                      = $soe::params::disable_ssh_password,
  $fix_rhel_systemd_tmpfs                    = $soe::params::fix_rhel_systemd_tmpfs,
  $fix_digital_ocean_disable_private_network = $soe::params::fix_digital_ocean_disable_private_network,

) inherits ::soe::params {

  # Include all desired base configuration

  if ($manage_hostname)       { require ::hostname }
  if ($manage_time_ntp)       { require ::ntp }
  if ($manage_updates)        { require ::soe::updates }
  if ($manage_swapspace)      { require ::soe::swapspace }
  if ($manage_services)       { require ::soe::services }

  if ($enable_sudo_wheel)     { require ::soe::sudo }
  if ($enable_newrelic)       { require ::newrelic::server::linux }
  if ($disable_ssh_password)  { require ::soe::sshnopassword }

  if ($manage_time_zone) {
    class { 'timezone':
      timezone => $manage_time_zone,
    }
  }


  # Packages

  if ($enable_repo_jethrocarr) { require ::repo_jethro }
  if ($enable_repo_epel)       { require ::epel }

  if ($::osfamily == "Debian") {
    # Make sure the APT module is invoked in SOE to avoid circular deps in other
    # Puppet modules or class definitions.
    class { '::apt': }
  }

  if ($packages_ensure) {
    ensure_packages($packages_ensure)
  }


  # Include fixes

  if ($fix_rhel_systemd_tmpfs)                      { include ::soe::fix::rhel_systemd_tmpfs }
  if ($fix_digital_ocean_disable_private_network)   { include ::soe::fix::digital_ocean_disable_private_network }

}
# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
