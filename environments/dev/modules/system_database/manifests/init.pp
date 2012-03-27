class system_database {
  $packagepath = $::lsbdistcodename ? {
      'squeeze' => "/usr/local/lib/python2.6/dist-packages"
  }
  package { "python2.6":
    ensure => latest;
  }
  file { "system_database.py":
    path   => "${packagepath}/system_database.py",
    source => "puppet:///modules/system_database/system_database.py",
    owner  => "root",
    group  => "staff",
    mode   => 0644;
  }
}
