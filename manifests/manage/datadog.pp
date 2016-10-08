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

    if (hiera('datadog_agent::puppet_run_reports', false)) {
      # Puppet reporting has been enabled. This should only be done on a Puppet
      # master, or a masterless Puppet deployment like Pupistry. The module does
      # most of the work, but we should use Augeas to set the reporting up in
      # the Puppet config file.

      augeas { "puppet enable datadog reports":
        context => "/files/etc/puppet/puppet.conf/main/",
        changes => "set reports datadog_reports"
      }
    }
  }

}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
