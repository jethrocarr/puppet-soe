# Sets up a minimal email configuration for all servers with an alias file that
# will redirect any root user email to the `email_root_destination` address if
# set.
#
class soe::manage::mail (
  $enable                 = true,
  $email_root_destination = undef,
  ){

  if ($enable) {
    # Install postfix on platforms that don't have a pre-installed MTA
    if ($::operatingsystem == 'Fedora') {
      package { 'postfix':
        ensure => 'installed',
        before => File['/etc/aliases'],
      }
    }

    # Install the mail aliases file
    file { '/etc/aliases':
      ensure => 'file',
      mode   => '0644',
      owner  => 'root',
      group  => $::kernel ? {
        'FreeBSD' => 'wheel',
        default   => 'root',
      },
      source => 'puppet:///modules/soe/manage/aliases',
      notify => Exec['update_/etc/aliases'],
    }

    exec { 'update_/etc/aliases':
      command     => 'newaliases',
      path        => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
      refreshonly => true,
    }
  }
}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
