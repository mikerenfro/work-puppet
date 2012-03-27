class maradns {
  include system_database
  package { "maradns":
    ensure => latest;
  }
  file { "dns-regen":
    path   => "/usr/local/sbin/dns-regen",
    source => "puppet:///modules/maradns/dns-regen",
    mode   => 0700,
    owner  => "root",
    group  => "root";
  }
  exec { "/usr/local/sbin/dns-regen":
    subscribe   => [ File["system_database.py"],
                     File["dns-regen"] ],
    refreshonly => true;
  }
}
