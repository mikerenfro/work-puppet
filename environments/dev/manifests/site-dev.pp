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
}

node gold {
  include ssh
}

node scratchy {
  include ssh
  include root_rsa_id
}
