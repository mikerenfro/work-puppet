class active_directory::client(
  $packages = $active_directory::client::params::packages,
  $provider = $active_directory::client::params::provider,
  $smbconf  = $active_directory::client::params::smbconf,
  $net      = $active_directory::client::params::net,
  $secrets  = $active_directory::client::params::secrets,
  $dc       = undef
) inherits active_directory::client::params {
  package { $packages:
    ensure   => present,
    provider => $provider
  }
  file {
    $smbconf:
      source  => "puppet:///modules/active_directory/smb.conf.$operatingsystem",
      require => Package[$packages],
      owner   => "root",
      group   => "root",
      mode    => 0644;
    
    $secrets:
      owner => "root",
      group => "root",
      mode  => 0600;

    "/etc/nsswitch.conf":
      source => "puppet:///modules/active_directory/nsswitch.conf.$operatingsystem",
      owner  => "root",
      group  => "root",
      mode   => 0644;
    "/etc/security/users.conf":
      source => [
                 "puppet:///modules/active_directory/users.conf.$fqdn",
                 "puppet:///modules/active_directory/users.conf.$operatingsystem",
                 "puppet:///modules/active_directory/users.conf.default", ];
    "/etc/krb5.conf":
      source => "puppet:///modules/active_directory/krb5.conf.$operatingsystem";
    "/usr/local/sbin/netjoin.sh":
      content => template("active_directory/netjoin.sh.erb"),
      owner   => "root",
      group   => "root",
      mode    => 0700,
      before  => Exec["netjoin"];
  }

  exec { "netjoin":
    command => "/usr/local/sbin/netjoin.sh $net $dc",
    creates => "$secrets",
    require => Package[$packages],
    before  => Service["winbind"];
  }

  service { "winbind":
    ensure => running,
    binary => $operatingsystem ? {
      /(Debian|Ubuntu)/ => undef,
      Solaris           => "/usr/local/sbin/winbindd"
    },
    pattern => $operatingsystem ? {
      /(Debian|Ubuntu)/ => "/usr/sbin/winbindd",
      Solaris           => "/usr/local/sbin/winbindd"
    },
    start => $operatingsystem ? {
      /(Debian|Ubuntu)/ => undef,
      Solaris           => "/usr/local/sbin/winbindd"
    },
    provider => $operatingsystem ? {
      /(Debian|Ubuntu)/ => debian,
      Solaris           => base
    },
    subscribe => [ File[$smbconf], File[$secrets] ];
  }
      
}
