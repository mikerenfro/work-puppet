class postfix {
  package { "postfix":
    ensure => present;
  }
  file { "main.cf":
    content => template('postfix/main.cf.erb'),
    mode    => "0644",
    path    => "/etc/postfix/main.cf";
  }
  service { "postfix":
    ensure    => running,
    subscribe => [ Package["postfix"], File["main.cf"] ];
  }
  @@shorewall::macro {
    "smtp-${fqdn}":
      comment => "Allow SMTP for ${fqdn}",
      macro   => "SMTP",
      target  => "ACCEPT",
      source  => "net",
      dest    => "loc:${ipaddress}";
  }      
}
