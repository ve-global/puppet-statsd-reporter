class statsd_reporter (
  $statsd_host = 'localhost',
  $statsd_port = 8125,
  $datacenter
) {
  file { '/etc/puppet-statsd-reporter':
    ensure  => directory,
    owner   => 'puppet',
    group   => 'puppet'
  }

  file { '/etc/puppet-statsd-reporter/statsd.yaml':
    ensure  => file,
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0444',
    content => template('statsd_reporter/statsd.yaml.erb'),
    require => File['/etc/puppet-statsd-reporter']
  }
}
