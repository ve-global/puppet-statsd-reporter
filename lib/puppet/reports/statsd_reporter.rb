require 'puppet'
require 'yaml'

begin
  require 'statsd'
rescue LoadError => e
  Puppet.info "You need the `statsd` gem to use the statsd report"
end

Puppet::Reports.register_report(:statsd_reporter) do

  configfile = '/etc/puppet-statsd-reporter/statsd.yaml'
  raise(Puppet::ParseError, "StatsD report config file #{configfile} not readable") unless File.exist?(configfile)
  config = YAML.load_file(configfile)
  STATSD_SERVER = config[:statsd_server]
  STATSD_PORT = config[:statsd_port]
  DATACENTER = config[:datacenter]

  desc <<-DESC
  Send notification of failed reports to StatsD.
  DESC

  def process
    statsdClient = Statsd.new STATSD_SERVER, STATSD_PORT

    Puppet.debug "Sending status for #{self.host} to StatsD server at #{STATSD_SERVER}"
    hostname = self.host.split('.')[0]
    self.metrics.each { |metric,data|
      data.values.each { |val|
        statname = "puppet.#{metric}.#{val[0]},datacenter=#{DATACENTER},host=#{hostname}"
        Puppet.debug "#{statname} #{val[2]}"
        statsdClient.gauge statname, val[2]
      }
    }
  end
end
