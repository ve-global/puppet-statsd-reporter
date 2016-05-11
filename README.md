Puppet StatsD Reporter
---

Publish puppet run metrics to statsd.

Installing:

- Add the module to your puppetfile
```ruby
mod 've-interactive/puppet-statsd-reporter',
  :git => 'https://github.com/ve-interactive/puppet-statsd-reporter.git',
  :ref => '1.0.0'
```

- Add the statsd_reporter class to your puppet master's role

```puppet
class { '::statsd_reporter': 
  host       => 'localhost', # optional (default: localhost)
  port       => 8125,        # optional (default: 8125)
  datacenter => 'us-west2'   # required
}
```
Note: the above config assumes that you also have statsd running locally on your puppet master

- Add the report to your `puppet.conf`

```
[master]
report = true
reports = statsd_reporter
pluginsync = true
[agent]
report = true
pluginsync = true
```
