# Provision a number of popular packages that we commonly desire that aren't
# always provisioned by the operating system itself. The param `extra` allows
# for extra packages to be define in Hiera in an array form.

class soe::manage::packages (
  $enable          = true,
  $extra           = undef,
  ) {

  if ($enable) {

    # Install base set
    $package_list = $::osfamily ? {
      'Debian' => ['net-tools',
                   'bsd-mailx',
                   'telnet',
                   'lsof',
                   'htop',
                   'iotop',
                   'strace',
                   'bzip2',
                   'augeas-tools',
                   'ruby-augeas'],
      'RedHat' => ['vim-enhanced',
                   'net-tools',
                   'bind-utils',
                   'mailx',
                   'telnet',
                   'lsof',
                   'htop',
                   'iotop',
                   'strace',
                   'bzip2',
                   'augeas',
                   'ruby-augeas',
                   'yum-utils',
                   'rpm-build'],
      'undef'  => [],
    }
    
    ensure_packages($package_list)


    # Install bonus extras from Hiera
    if ($extra) {
      ensure_packages($extra)
    }

  }
}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
