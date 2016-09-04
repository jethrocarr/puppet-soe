# Because of the nature and scale of this module, all the logic is in
# sub-classes, each which features a `$enable` param that can be used
# to disable it via Hiera.
#
# For configuration details, please refer to the specific sub-class
# configuration file.

class soe {

  include ::soe::manage::hostname
  include ::soe::manage::mail
  include ::soe::manage::time
  include ::soe::manage::updates
  include ::soe::manage::swapspace
  include ::soe::manage::sudo
  include ::soe::manage::ssh
  include ::soe::manage::logger
  include ::soe::manage::repos
  include ::soe::manage::packages

  include ::soe::fix::debian_apt_dep
  include ::soe::fix::digital_ocean_disable_private_network
  include ::soe::fix::rhel_disable_avahi
  include ::soe::fix::rhel_systemd_tmpfs

}
# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
