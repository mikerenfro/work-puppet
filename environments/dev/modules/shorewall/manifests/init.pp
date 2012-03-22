class shorewall {
  exec {"shorewall-restart":
    command     => "/etc/init.d/shorewall restart",
    refreshonly => true
  }
  file { "/etc/shorewall/conf.d":
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => 0700,
    recurse => true,
    purge   => true, # true to clean up extra files, false to let them stay
    notify  => Exec["shorewall-restart"];
  }
  file { "/etc/shorewall/conf.d/README":
    content => "This folder is managed by puppet. Make changes on the\npuppetmaster instead of manually.\n",
    owner   => root,
    group   => root,
    mode    => 0600
  }
}
