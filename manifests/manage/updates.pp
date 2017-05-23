# Ensure the operating system gets security and bug fixes.
class soe::manage::updates (
  $enable               = true,
  $notify_email_address = 'root',
  ) {

  if ($enable == true) {

    if ($::osfamily == "RedHat") {
      # Install the yum-cron agent to do regularly updates.

      package { 'yum-cron':
        ensure        => installed,
        allow_virtual => true,
      }

      file { '/etc/yum/yum-cron.conf':
        ensure   => 'file',
        owner    => 'root',
        group    => 'root',
        mode     => '0644',
        content  => template('soe/manage/yum-cron.conf.erb'),
        require  => Package['yum-cron'],
      }

      service { 'yum-cron':
        ensure => running,
        enable => true,
      }
    }

    if ($::operatingsystem == "Debian") {
      # Unattended upgrades will update daily by default.
      package { 'unattended-upgrades':
        ensure        => installed,
        allow_virtual => true,
      } ->

      # Make sure the /etc/apt/apt.conf.d/20auto-upgrades file has been created
      # otherwise the unattended upgrades won't be run.
      file { '/etc/apt/apt.conf.d/20auto-upgrades':
        ensure   => 'file',
        owner    => 'root',
        group    => 'root',
        mode     => '0644',
        content  => template('soe/manage/apt-20auto-upgrades.conf.erb'),
      }
    }

    if ($::operatingsystem == "Ubuntu") {
      # Note: this will only support systemd Ubuntu (16.04 LTS+)

      # Unattended upgrades will update daily by default.
      package { 'unattended-upgrades':
        ensure        => installed,
        allow_virtual => true,
      } ->

      # Ensure the apt-daily service is enabled. This one isn't always running
      # and is difficult to manage properly with native service resource since
      # it's *usually* stopped, but sometimes it's running and we wouldn't want
      # Puppet to actually stop it if it was running...
      exec { 'ensure-apt-daily-service-enabled':
        path    => "/bin:/sbin:/usr/bin:/usr/sbin",
        command => 'systemctl enable apt-daily.service',
        onlyif  => 'systemctl status apt-daily.service | grep -q disabled',
      } ->

      # We can't manage timers with Puppet, so we do this the hard way,
      # making sure we are running the timer. If it's not running, key tasks
      # such as unattended upgrades don't run.
      exec { 'ensure-apt-daily-timer-enabled':
        path    => "/bin:/sbin:/usr/bin:/usr/sbin",
        command => 'systemctl enable apt-daily.timer',
        onlyif  => 'systemctl status apt-daily.timer | grep -q disabled',
      } ->

      exec { 'ensure-apt-daily-timer-running':
        path    => "/bin:/sbin:/usr/bin:/usr/sbin",
        command => 'systemctl start apt-daily.timer',
        onlyif  => 'systemctl status apt-daily.timer | grep -q inactive',
      }

    }
  }

}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
