# Configure a swapfile
class soe::swapspace (
  $swapfilesize = $soe::manage_swapspace
) {

  swap_file::files { 'default':
    ensure       => present,
    swapfile     => '/tmp/.swapfile',
    swapfilesize => "${swapfilesize} MB"
  }
}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
