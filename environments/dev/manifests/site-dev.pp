node default {}

node router {
  include ssh
  include root_rsa_id
  include shorewall
  include maradns # also includes system_database
  include dhcpd # also includes system_database
  include debian_installer
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
    "www-client-router.caedev.local":
      comment => "Allow http access from router (for package installation)",
      macro   => "Web",
      target  => "ACCEPT",
      source  => "\$FW",
      dest    => "net";
    "ssh-router.caedev.local":
      comment => "Allow ssh access from internal network",
      macro   => "SSH",
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
  class { 'active_directory::client':
    dc => "dc.caedev.local"
  }
  include nfs::client
}

node files {
  include ssh
  include root_rsa_id
  class { 'active_directory::client':
    dc => "dc.caedev.local"
  }
  include nfs::server
}

node dc {
  include active_directory::server
  include kdc
}
