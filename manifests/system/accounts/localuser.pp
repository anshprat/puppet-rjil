## Define: rjil::system::accounts::localuser

define rjil::system::accounts::localuser(
  $realname,
  $sshkeys = '',
  $password = '*',
  $shell = '/bin/bash'
) {
  if ! defined (Group[$title]) {
    group { $title:
      ensure => present,
    }
  }

  if ! defined (User[$title]) {
    user { $title:
      ensure     => present,
      comment    => $realname,
      gid        => $title,
      home       => "/home/${title}",
      managehome => true,
      password   => $password,
      membership => 'minimum',
      require    => Group[$title],
      shell      => $shell,
    }

    file { "${title}_sshdir":
      ensure  => directory,
      name    => "/home/${title}/.ssh",
      owner   => $title,
      group   => $title,
      mode    => '0700',
      require => User[$title],
    }

    file { "${title}_keys":
      ensure  => present,
      content => $sshkeys,
      group   => $title,
      mode    => '0400',
      name    => "/home/${title}/.ssh/authorized_keys",
      owner   => $title,
      require => File["${title}_sshdir"],
    }
  }
}
