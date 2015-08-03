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
    ##
    # We have reached here, then it means puppet_enable is true, but never hurts to cross check.
    ##

  if ($consulkv['upgrade_component'] == 'ceph' and $consulkv['enable_upgrade'] == 'True' and $consulkv['enable_puppet'] == 'True'){
    ##
    # The below is not required for prod but is only for testing gates upgrade in gates
    ##
    if ($consulkv['gate_update_ceph_repo'] == 'True'){
        file {'delete_ceph_giant_repo':
          path   => '/etc/apt/sources.list.d/ceph.list',
          ensure => absent,
        }
       apt::source { 'ceph_hammer_repo':
          comment  => 'ceph hammer repo',
          location => 'http://ceph.com/',
          release  => 'debian-hammer',
          repos    => 'main',
          key      => {
            'id'     => '17ED316D',
            'server' => 'keyserver.ubuntu.com',
          },
        }
        exec { "/usr/bin/apt-get -y upgrade":
          refreshonly => true,
          subscribe => File["/etc/apt/sources.list.d/ceph_hammer_repo.list"],
          timeout => 3600,
        }
    }

        if (('stmonleader1' in $::hostname) and ($consulkv['mon_restart_done'] != 'True')){
            file { "/tmp/mon_restart_lock.puppet":
                notify  => Service["ceph-mon"],
            }
            service { "ceph-mon":
                ensure => running,
            }
            exec {"/usr/bin/ls": #/path/to/mon/quorum/check
#                notify => to_upgrade_consul_mon_restart_done
            }
        }
    notify{'this works':}
   }else{
    notify{'this fails':}
   }
}
