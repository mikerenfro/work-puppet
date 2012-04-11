class nfs::host {
  package { ["krb5-clients", "krb5-user"]:
    ensure => latest;
  }
  package { "nfs-common":
    ensure => latest;
  }
  file { "/etc/idmapd.conf":
    source => "puppet:///modules/nfs/idmapd.conf";
  }
  file { "/etc/default/nfs-common":
    source => "puppet:///modules/nfs/nfs-common";
  }
  service { "nfs-common":
    subscribe => File["/etc/default/nfs-common"];
  }
  # Create Kerberos principal on KDC
  @@kdc::principal { "nfs-${hostname}":
    service => "nfs",
    hostname => "${hostname}"
  }
}
