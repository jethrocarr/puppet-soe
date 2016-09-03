# Make sure the APT module is invoked in SOE to avoid circular deps in other
# Puppet modules or class definitions, as long as SOE is defined it in a
# pre-main stage.

class soe::fix::debian_apt_dep (
  $enable = true,
) {

  if ($enable) {
    if ($::osfamily == "Debian") {
      class { '::apt': }
    }
  }
}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
