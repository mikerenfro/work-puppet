class dovecot {
  package { "dovecot-imapd":
    ensure => present;
  }
  file { "dovecot.conf":
    content => template('dovecot/dovecot.conf.erb'),
    mode    => "0644",
    path    => "/etc/dovecot/dovecot.conf"
  }
  service { "dovecot":
    ensure    => running,
    subscribe => [ Package["dovecot-imapd"], File["dovecot.conf"] ];
  }
  @@shorewall::macro {
    "imap-${fqdn}":
      comment => "Allow unencrypted IMAP for ${fqdn}",
      macro   => "IMAP",
      target  => "ACCEPT",
      source  => "net",
      dest    => "loc:${ipaddress}";
    "imaps-${fqdn}":
      comment => "Allow encrypted IMAP for ${fqdn}",
      macro   => "IMAPS",
      target  => "ACCEPT",
      source  => "net",
      dest    => "loc:${ipaddress}";
  }
}
