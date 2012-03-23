class root_rsa_id {
  file { "/root/.ssh":
    require => Class["ssh"],
    ensure  => directory,
    mode    => 0700,
    owner   => "root",
    group   => "root";
  }
  file { "/root/.ssh/authorized_keys":
    source  => "puppet:///modules/${module_name}/id_rsa.pub",
    mode    => 0600,
    owner   => "root",
    group   => "root",
    require => File["/root/.ssh"];
  }
}
