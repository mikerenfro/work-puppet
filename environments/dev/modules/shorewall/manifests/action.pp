define shorewall::action (
  $comment,
  $action,
  $source,
  $dest,
  $proto,
  $dest_ports,
  $source_ports
) {
    file {
      "shorewall_action_${name}":
        path    => "/etc/shorewall/conf.d/${name}.conf",
        content => "# ${comment}\n${action} ${source} ${dest} ${proto} ${dest_ports} ${source_ports}\n",
        owner   => root,
        group   => root,
        mode    => 0644,
        notify  => Exec["shorewall-restart"];
    }
}
