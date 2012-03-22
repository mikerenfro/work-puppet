node default {}

node router {
  include ssh
  include root_rsa_id
  include shorewall
  shorewall::action { "puppetd-router.caedev.local":
    comment      => "Allow puppetd traffic",
    action       => "ACCEPT",
    source       => "\$FW",
    dest         => "loc",
    proto        => "tcp",
    source_ports => "-",
    dest_ports   => "8140:8141"
  }
  shorewall::macro {
    "dns-router.caedev.local":
      comment => "# Allow DNS server on router",
      macro   => "DNS",
      target  => "ACCEPT",
      source  => "loc",
      dest    => "\$FW";
    "tftpd-router.caedev.local":
      comment => "# Allow TFTP server on router",
      macro   => "TFTP",
      target  => "ACCEPT",
      source  => "loc",
      dest    => "\$FW";
  }
}

node gold {
  include ssh
}

node scratchy {
  include ssh
  include root_rsa_id
}
