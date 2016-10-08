# Installs the Datadog agent
class soe::manage::datadog (
  $enable = true,
  ) {

  # Enable the Datadog agent when runing on GNU/Linux platforms. This feature
  # requires the use of the datadog/datadog_agent Puppet module.
  $available = $::kernel ? {
    'Linux'   => hiera('datadog_agent::api_key', false) ? {
      false   => false,
      default => true,
    },
    default => false,
  }

  if ($enable and $available) {
    require ::datadog_agent
  }

}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
