# Installs the Newrelic server agent.
class soe::manage::newrelic (
  $enable = true,
  ) {

  # Enable the Newrelic server agent by default, however it's only available
  # for the GNU/Linux platform. We also do a check to make sure the license
  # key first, otherwise the Puppet module fails to run and jams the whole
  # Puppet run. This feature requires the fsalum/newrelic module.
  $available = $::kernel ? {
    'Linux'   => hiera('newrelic::server::linux::newrelic_license_key', false) ? {
      false   => false,
      default => true,
    },
    default => false,
  }

  if ($enable and $available) {
    require ::newrelic::server::linux
  }

}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
