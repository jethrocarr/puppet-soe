# Define logging configuration.

class soe::manage::repos (
  $enable          = true,
  $repo_epel       = true,
  $repo_jethrocarr = false,
  ) {

  if ($enable) {

    if ($repo_epel) {
      # Install the EPEL repo. Recommended for CentOS and other EL variants, but
      # be wary with Amazon Linux as not all packages will work properly there.

      if ($::osfamily == 'RedHat') {
        require ::epel
      }
    }

    if ($repo_jethrocarr) {
      # Install the repos from repos.jethrocarr.com. This is disabled by
      # default as it's not particular mainstream like EPEL.

      if ($::osfamily == 'RedHat' or $::osfamily == 'Debian') {
        require ::repo_jethro
      }
    }
  }
}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
