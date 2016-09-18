# Sets up a minimal email configuration for all servers with an alias file that
# will redirect any root user email to the `email_root_destination` address if
# set.
#
class soe::manage::mail (
  $enable                 = true,
  $email_root_destination = undef,
  ){

  if ($enable) {

    # Install package to provide newaliases if not already present. Generally
    # this means installing an MTA such as postfix
    $newaliases_deps = $::operatingsystem ? {
      'Fedora'  => ['postfix'],
      'Ubuntu'  => ['mail-transport-agent'],
      default   => [],
    }

    ensure_packages($newaliases_deps)


    # Install the mail aliases file
    file { '/etc/aliases':
      ensure => 'file',
      mode   => '0644',
      owner  => 'root',
      group  => $::kernel ? {
        'FreeBSD' => 'wheel',
        default   => 'root',
      },
      content => template("soe/manage/aliases.erb"),
      notify  => Exec['update_/etc/aliases'],
    }

    exec { 'update_/etc/aliases':
      command     => 'newaliases',
      path        => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
      refreshonly => true,
      require     => Package[$newaliases_deps],
    }
  }
}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
