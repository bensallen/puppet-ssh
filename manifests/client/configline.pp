define ssh::client::configline (
  $ensure = present,
  $value = false
) {
  include ssh::client

  Augeas {
    context => "/files${ssh::params::ssh_config}",
    require => Class['ssh::client::config'],
  }

  case $ensure {
    present: {
      augeas { "ssh_config_${name}":
        changes => "set ${name} ${value}",
        onlyif  => "get ${name} != ${value}",
      }
    }
    add: {
      augeas { "ssh_config_${name}":
        onlyif  => "get ${name}[. = '${value}'] != ${value}",
        changes => [
          "ins ${name} after ${name}[last()]",
          "set ${name}[last()] ${value}"
        ],
      }
    }
    absent: {
      augeas { "ssh_config_${name}":
        changes => "rm ${name}",
        onlyif  => "get ${name}",
      }
    }
    default: {
      fail("ensure value must be present, add or absent, not ${ensure}")
    }
  }
}
