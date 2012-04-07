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
      @@shorewall::action {
        "kerberos-tcp-${fqdn}":
          comment      => "Enable inbound Kerberos for ${fqdn} (TCP)",
          action       => "ACCEPT",
          source       => "net",
          dest         => "loc:${ipaddress_local_area_connection}",
          proto        => "tcp",
          dest_ports   => "88",
          source_ports => "-";
        "kerberos-udp-${fqdn}":
          comment      => "Enable inbound Kerberos for ${fqdn} (UDP)",
          action       => "ACCEPT",
          source       => "net",
          dest         => "loc:${ipaddress_local_area_connection}",
          proto        => "udp",
          dest_ports   => "88",
          source_ports => "-";
        "kerberos-v5-tcp-${fqdn}":
          comment      => "Enable inbound Kerberos V5 for ${fqdn} (TCP)",
          action       => "ACCEPT",
          source       => "net",
          dest         => "loc:${ipaddress_local_area_connection}",
          proto        => "tcp",
          dest_ports   => "464",
          source_ports => "-";
        "kerberos-v5-udp-${fqdn}":
          comment      => "Enable inbound Kerberos V5 for ${fqdn} (UDP)",
          action       => "ACCEPT",
          source       => "net",
          dest         => "loc:${ipaddress_local_area_connection}",
          proto        => "udp",
          dest_ports   => "464",
          source_ports => "-";
        "rpc-https-${fqdn}":
          comment      => "RPC over HTTPS for ${fqdn}",
          action       => "ACCEPT",
          source       => "net",
          dest         => "loc:${ipaddress_local_area_connection}",
          proto        => "tcp",
          dest_ports   => "593",
          source_ports => "-";
        "global-catalog-server-${fqdn}":
          comment      => "Global catalog server for ${fqdn}",
          action       => "ACCEPT",
          source       => "net",
          dest         => "loc:${ipaddress_local_area_connection}",
          proto        => "tcp",
          dest_ports   => "3268:3269",
          source_ports => "-";
        "file-replication-${fqdn}":
          comment      => "File replication for ${fqdn}",
          action       => "ACCEPT",
          source       => "net",
          dest         => "loc:${ipaddress_local_area_connection}",
          proto        => "tcp",
          dest_ports   => "4997",
          source_ports => "-";
        "active-directory-replication-${fqdn}":
          comment      => "Active Directory replication for ${fqdn}",
          action       => "ACCEPT",
          source       => "net",
          dest         => "loc:${ipaddress_local_area_connection}",
          proto        => "tcp",
          dest_ports   => "4998:4999",
          source_ports => "-";
        "dynamic-rpc-group-policy-dfs-${fqdn}":
          comment      => "Dynamic RPC, Group Policy, and DFS for ${fqdn}",
          action       => "ACCEPT",
          source       => "net",
          dest         => "loc:${ipaddress_local_area_connection}",
          proto        => "tcp",
          dest_ports   => "5000:6000",
          source_ports => "-";
        "dfsr-rpc-${fqdn}":
          comment      => "Allow DFS replication RPC for ${fqdn}",
          action       => "ACCEPT",
          source       => "net",
          dest         => "loc:${ipaddress_local_area_connection}",
          proto        => "tcp",
          dest_ports   => "5722",
          source_ports => "-";
      }
      @@shorewall::macro {
        "ldap-${fqdn}":
          comment => "Allow unencrypted LDAP for ${fqdn}",
          macro   => "LDAP",
          target  => "ACCEPT",
          source  => "net",
          dest    => "loc:${ipaddress_local_area_connection}";
        "ldaps-${fqdn}":
          comment => "Allow encrypted LDAP for ${fqdn}",
          macro   => "LDAPS",
          target  => "ACCEPT",
          source  => "net",
          dest    => "loc:${ipaddress_local_area_connection}";
        "ntp-${fqdn}":
          comment => "Allow NTP for ${fqdn}",
          macro   => "NTP",
          target  => "ACCEPT",
          source  => "net",
          dest    => "loc:${ipaddress_local_area_connection}";
        "smb-${fqdn}":
          comment => "Allow SMB for ${fqdn}",
          macro   => "SMB",
          target  => "ACCEPT",
          source  => "net",
          dest    => "loc:${ipaddress_local_area_connection}";
      }
    }
    default: {
      err("active_directory::server class is for Windows systems only, but ${fqdn} runs $operatingsystem")
    }
  }
}
