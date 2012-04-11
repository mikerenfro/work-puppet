class nfs::server {
  include nfs::host
  package { "nfs-kernel-server":
    ensure => latest;
  }
  file {
    "exports":
      path    => "/etc/exports",
      source  => "puppet:///modules/nfs/exports",
      mode    => 0644,
      require => Package["nfs-kernel-server"];
    "nfs-kernel-server":
      path    => "/etc/default/nfs-kernel-server",
      source  => "puppet:///modules/nfs/nfs-kernel-server",
      require => Package["nfs-kernel-server"];
  }
  service {
    "nfs-kernel-server":
      ensure => running,
      subscribe => [ File["exports"], File["nfs-kernel-server"] ];
  }
  file {
    "export-root":
      path   => "/export",
      ensure => directory,
      mode   => 0755;
    "export-home":
      require => File["export-root"],
      path    => "/export/home",
      ensure  => directory,
      mode    => 0755;
  }
  mount {
    "/export/home":
      ensure  => mounted,
      device  => "/home",
      fstype  => "none",
      options => "ro,bind",
      dump    => "0",
      pass    => "0"
  }
}
