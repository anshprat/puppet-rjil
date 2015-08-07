#
# Class rjil::ceph::upgrade
# Purpose: Upgrade ceph on st* and cp* nodes
#
# == Parameters
#
# [*enable_ceph_upgrade*]
#  dummy param not yet used
#
#

class rjil::ceph::upgrade (
  $enable_ceph_upgrade = true,
) {
  #get all the configure values from consul
  $consulkv = consulr_kv({
              action => 'get',
              scope_param => $::hostname,
              })
  notify{$conslkv:}
    ###########################################################
    # We have reached here, then it means puppet_enable is true, but never hurts to cross check.
    # prod upgrade code starts
    # One more failsafe - ensure the upgrade date is for today
    # First restart the mon on stmonleader
    ###########################################################
  if ($consulkv['upgrade_component'] == 'ceph' and $consulkv['enable_upgrade'] == 'True' and $consulkv['enable_puppet'] == 'True'){
        $ceph_upgrade_date = $consulkv['ceph_upgrade_date']
        $today = generate('/bin/date','+%F')

        ##
        # Using in rather than == as $ today seems to have something extra like #12 in the end
        #(/Stage[main]/Rjil::Ceph::Upgrade/Notify[Planned ceph upgrade is 2015-08-16 , today is 2015-08-16#012]/message) defined 'message' as 'Planned ceph upgrade is 2015-08-16 , today is 2015-08-16
        ##

        if( $ceph_upgrade_date in $today ){
            if ((dns_resolve('stmonleader.service.consul') == $::ipaddress) and ($consulkv['mon_restart_done'] != 'True')){
                file { '/tmp/mon_restart_lock.puppet':
                    ensure  => exists,
                    notify  => Service["ceph-mon.$::hostname"],
                }
                exec {'/bin/ls': #/path/to/mon/quorum/check
                }
                consul_kv {
                        "config_state/host/$::hostname/mon_restart_done": value => 'true';
                }
                ##
                # Find out the next node to be updated?
                ##
            }
        } else {
            notify{"Planned ceph upgrade is $ceph_upgrade_date , today is $today":}
        }

    notify{'this works':}
    } else {
        notify{'this fails':}
    }
}

class {'rjil::ceph::upgrade': }
