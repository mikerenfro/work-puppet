class dhcpd {
  include system_database
  package { "isc-dhcp-server":
    ensure => latest;
  }
  file { "dhcp-regen":
    path   => "/usr/local/sbin/dhcp-regen",
    source => "puppet:///modules/dhcpd/dhcp-regen",
    mode   => 0700,
    owner  => "root",
    group  => "root";
  }
  exec { "/usr/local/sbin/dhcp-regen":
    subscribe   => [ File["system_database.py"],
                     File["dhcp-regen"],
                     Package["isc-dhcp-server"] ],
    refreshonly => true;
  }
}
