class soe::params {

  ## Operating System

  # Use jethrocarr/hostname for configuration. You can configure any aspect
  # of the module via Hiera, the key bit you are likely to want to set is
  # the domain with `hostname::domain`. For more information, refer to the
  # docs at: https://github.com/jethrocarr/puppet-hostname
  $manage_hostname = true

  # Manage swapfile - some of our smaller cloud servers don't always have a lot
  # of RAM and can run short when doing memory hungry operations like Puppet
  # runs and Yum updates. So it's important to setup a swap file on any of
  # these small systems. Note that we use a swapfile due to many cloud servers
  # only having a single mounted volume and can't be partitioned further.
  #
  # Param is either false, or set to number of MBs of swap space desired. By
  # default we make this a fixed 1GB, going above this size isn't recommended.
  #
  # For more arguments for/against swap space, please refer to:
  # 
  if ($::memorysize_mb > 1024) {
    $manage_swap_space = 1024
  } else {
    $manage_swap_space = false
  }

  # Enable NTP and set a specific timezone.
  $manage_time_ntp  = true
  $manage_time_zone = 'UTC'



  ## Security

  # Install tools/configuration to automatically manage security and OS updates
  # from the upstream vendor repositories.
  $manage_updates = true
  $manage_updates_emailto = 'root'

  # Setup sudo to permit root access for any users in the `wheel` group without
  # requiring a password.
  $enable_sudo_wheel = true

  # Disable password-based authentication by default. You should really, really
  # not change this, keys are the only way to have a secure server with SSH on
  # the public web.
  $disable_ssh_password = true




  ## Fixes

  # Enable various bug/sanity fixes. These are documented under each file in
  # `manifests/fixes/*.pp` and are generally safe to leave enabled as they'll
  # only perform actions when appropiate.

  $fix_rhel_systemd_tmpfs = true
  $fix_digital_ocean_disable_private_network = true


  ## Cloud Services

  # Enable the Newrelic server agent by default, however it's only available
  # for the GNU/Linux platform. We also do a check to make sure the license
  # key first, otherwise the Puppet module fails to run and jams the whole
  # Puppet run. This feature requires the fsalum/newrelic module.
  $enable_newrelic = $::kernel ? {
    'Linux'   => hiera('newrelic::server::linux::newrelic_license_key', false) ? {
      'false' => false,
      'undef' => true,
    },
    'undef' => false,
  }




}
# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
