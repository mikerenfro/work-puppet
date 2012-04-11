class kdc {
  case $operatingsystem {
    'windows': {
      $kdc_dir = "c:/users/administrator/kdc"
      file {
        "kdc_dir":
          path   => $kdc_dir,
          mode   => 0700,
          ensure => directory;
        "create-krb-user.ps1":
          path   => "${kdc_dir}/create-krb-user.ps1",
          source => "puppet:///modules/${module_name}/create-krb-user.ps1",
          require => File["kdc_dir"];
      }
      Kdc::Principal <<||>>
    }
    default: {
      err("kdc class is for Windows systems only, but ${fqdn} runs ${operatingsystem}")
    }
  }
}
