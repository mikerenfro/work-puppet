class debian_installer {
  @@shorewall::macro { "tftpd-${fqdn}":
    comment => "Allow TFTP from the local network",
    macro   => "TFTP",
    target  => "ACCEPT",
    source  => "loc",
    dest    => "\$FW"
  }
  include dhcpd
  package { "tftpd-hpa":
    ensure => latest;
  }
  file { "mirror-netboot":
    path   => "/usr/local/sbin/mirror-netboot",
    source => "puppet:///modules/debian_installer/mirror-netboot",
    mode   => 700,
    owner  => "root",
    group  => "root";
  }
  cron { "mirror-netboot":
    command => "/usr/local/sbin/mirror-netboot",
    user    => "root",
    hour    => 7,
    minute  => 0,
    require => [ File["mirror-netboot"],
                 Package["tftpd-hpa"] ];
  }
  exec { "mirror-netboot":
    command => "/usr/local/sbin/mirror-netboot",
    creates => "/srv/tftp/pxelinux.0",
    require => [ File["mirror-netboot"],
                 Package["tftpd-hpa"] ];
  }
  file { "cae-amd64.cfg":
    path    => "/srv/tftp/debian-installer/amd64/boot-screens/cae-amd64.cfg",
    content => template('debian_installer/cae-amd64.cfg.erb'),
    mode    => 644,
    require => Exec["mirror-netboot"];
  }
  file { "syslinux-amd64.cfg":
    path    => "/srv/tftp/debian-installer/amd64/boot-screens/syslinux.cfg",
    source  => "puppet:///modules/debian_installer/syslinux-amd64.cfg",
    mode    => 644,
    require => Exec["mirror-netboot"];
  }
  file { "cae-i386.cfg":
    path    => "/srv/tftp/debian-installer/i386/boot-screens/cae-i386.cfg",
    content => template('debian_installer/cae-i386.cfg.erb'),
    mode    => 644,
    require => Exec["mirror-netboot"];
  }
  file { "syslinux-i386.cfg":
    path    => "/srv/tftp/debian-installer/i386/boot-screens/syslinux.cfg",
    source  => "puppet:///modules/debian_installer/syslinux-i386.cfg",
    mode    => 644,
    require => Exec["mirror-netboot"];
  }
}
