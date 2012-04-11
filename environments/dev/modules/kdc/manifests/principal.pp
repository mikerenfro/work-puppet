define kdc::principal($service, $hostname) {
  exec {
    "create-krb-user-${service}-${hostname}":
      command => "c:\\windows\\system32\\windowspowershell\\v1.0\\powershell.exe -executionpolicy remotesigned -file c:\\users\\administrator\\kdc\\create-krb-user.ps1 ${service} ${hostname}",
      creates => "c:\\users\\administrator\\kdc\\${service}${hostname}.keytab"
  }
}
