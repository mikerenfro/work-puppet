class spamassassin {
  package { ["spamassassin", "spamc"]:
    ensure => present;
  }
  file { "spamassassin.default":
    source  => "puppet:///modules/spamassassin/spamassassin.default",
    path    => "/etc/default/spamassassin",
    require => Package["spamassassin"];
  }
  service { "spamassassin":
    ensure    => running,
    subscribe => [ Package["spamassassin"],
                   Package["spamc"],
                   File["spamassassin.default"] ];
  }
}
