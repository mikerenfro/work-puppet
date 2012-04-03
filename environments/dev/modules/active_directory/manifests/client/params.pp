class active_directory::client::params {
  $packages = $operatingsystem ? {
    /(Debian|Ubuntu)/ => [ "krb5-config", "libpam-krb5",
                           "samba-common", "winbind" ],
    Solaris           => [ "krb5_lib_dev", "krb5_user",
                           "openldap_devel", "openldap_client",
                           "gcc4core" ],
  }
  $provider = $operatingsystem ? {
    /(Debian|Ubuntu)/ => "apt",
    Solaris           => "blastwave"
  }
  $smbconf = $operatingsystem ? {
    /(Debian|Ubuntu)/ => "/etc/samba/smb.conf",
    Solaris           => "/usr/local/lib/smb.conf"
  }
  $net = $operatingsystem ? {
    /(Debian|Ubuntu)/ => "/usr/bin/net",
    Solaris           => "/usr/local/bin/net"
  }
  $secrets = $operatingsystem ? {
    /(Debian|Ubuntu)/ => "/var/lib/samba/secrets.tdb",
    Solaris           => "/usr/local/private/secrets.tdb"
  }
}
