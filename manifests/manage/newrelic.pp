# Warning: The Newrelic server agent is EOL and will be removed at some point.
# This class now defaults to removing it given it won't be working much longer.
class soe::manage::newrelic (
  $enable = false,
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


  if ($available) {
    if ($enable) {
      # Install using the Newrelic server agent
      require ::newrelic::server::linux
    } else {
      # Ensure the agent is purged
			service { 'newrelic-sysmond':
				ensure     => 'stopped',
				enable     => false,
				hasrestart => true,
				hasstatus  => true,
			} ->
			package { 'newrelic-sysmond':
				ensure  => 'absent',
			}

      # Uninstall the repos given we are no longer using the server agent
	    file { '/etc/apt/sources.list.d/newrelic.list':
        ensure => 'absent'
      }
      file { '/etc/yum.repos.d/newrelic.repo':
        ensure => 'absent'
      }
    }
  }

}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
