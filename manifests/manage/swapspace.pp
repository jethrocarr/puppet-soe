# Manage swapfile - some of our smaller cloud servers don't always have a lot
# of RAM and can run short when doing memory hungry operations like Puppet
# runs and Yum updates. So it's important to setup a swap file on any of
# these small systems. Note that we use a swapfile due to many cloud servers
# only having a single mounted volume and can't be partitioned further.

class soe::manage::swapspace (
  $enable         = true,
  $onlyifmembelow = '1024',
  $swapfilesize   = '1024',
  $swapfile       = '/tmp/.swapfile',
) {

  if ($enable) {
    if ($::memorysize_mb < $onlyifmembelow) {

      swap_file::files { 'default':
        ensure       => present,
        swapfile     => $swapfile,
        swapfilesize => "${swapfilesize} MB"
      }
    }
  }

}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
