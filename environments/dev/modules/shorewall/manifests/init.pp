class shorewall {
  exec {"shorewall-restart":
    command     => "/etc/init.d/shorewall restart",
    refreshonly => true
  }
}
