# Configure NTP and timezone

class soe::manage::time (
  $enable   = true,
  $timezone = hiera('timezone::timezone', 'UTC'),
) {
  
  if ($enable == true) {
    require ::ntp
    
    class { 'timezone':
      timezone => $timezone,
    }
  }

}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
