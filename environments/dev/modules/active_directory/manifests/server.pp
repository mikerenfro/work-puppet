class active_directory::server {

  case $operatingsystem {
    'windows' : {
      # Requires script to create netjoin account for adding winbind
      # clients, plus netauth account for authenticating Apache or other
      # users over LDAP
      file { "server_boostrap.cmd":
        path    => "C:/Users/Administrator/server_bootstrap.cmd",
        mode    => "0700",
        replace => false,
        content => template('active_directory/server_bootstrap.cmd.erb')
      }
    }
    default: {
      err("active_directory::server class is for Windows systems only, but $fqdn runs $operatingsystem")
    }
  }
}
