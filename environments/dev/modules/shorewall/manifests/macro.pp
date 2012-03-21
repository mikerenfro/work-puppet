define shorewall::macro (
  $comment,
  $macro,
  $target,
  $source,
  $dest
) {
    file {
      "shorewall_macro_${name}":
        path    => "/etc/shorewall/conf.d/${name}.conf",
        content => "# ${comment}\n${macro}(${target}) ${source} ${dest}\n",
        owner   => root,
        group   => root,
        mode    => 0644,
        notify  => Exec["shorewall-restart"];
    }
}
