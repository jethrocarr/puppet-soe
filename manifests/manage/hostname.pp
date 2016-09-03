# Use jethrocarr/hostname for configuration. You can configure any aspect
# of the module via Hiera, the key bit you are likely to want to set is
# the domain with `hostname::domain`. For more information, refer to the
# docs at: https://github.com/jethrocarr/puppet-hostname

class soe::manage::hostname (
  $enable = true,
) {
  
  if ($enable == true) {
    require ::hostname
  }

}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
