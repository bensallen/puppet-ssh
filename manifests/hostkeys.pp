define ssh_extra_keys($type, $host_aliases, $key) {
  @@sshkey { $name:
    host_aliases => $host_aliases,
    type	 => $type,
    key		 => $key,
  }
}

class ssh::hostkeys inherits ssh::params {
  $ipaddresses = ipaddresses()
  $host_aliases = flatten([ $::fqdn, $::hostname, $ipaddresses ])

  @@sshkey { "${::fqdn}_dsa":
    host_aliases => $host_aliases,
    type         => dsa,
    key          => $::sshdsakey,
  }
  @@sshkey { "${::fqdn}_rsa":
    host_aliases => $host_aliases,
    type         => rsa,
    key          => $::sshrsakey,
  }
  if $::sshecdsakey {
    @@sshkey { "${::fqdn}_ecdsa":
      host_aliases => $host_aliases,
      type         => 'ecdsa-sha2-nistp256',
      key          => $::sshecdsakey,
    }
  }
  if $ssh_extra_keys {
    create_resources(ssh_extra_keys, $ssh_extra_keys)
  }
}
