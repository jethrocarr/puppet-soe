# Ensure the operating system gets security and bug fixes.
class soe::updates {


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
      content  => template('soe/yum-cron.conf.erb'),
      require  => Package['yum-cron'],
    }

    service { 'yum-cron':
      ensure => running,
      enable => true,
    }
  }

}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
