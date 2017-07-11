# frozen_string_literal: true

require 'puppetdb'

class PuppetdbClient
  def initialize(endpoint)
    @endpoint = endpoint
    @client = PuppetDB::Client.new(server: @endpoint,
                                   pem: { key: Settings.PUPPET_KEY,
                                          cert: Settings.PUPPET_CERT,
                                          ca_file: Settings.PUPPET_CA_FILE })
  end

  def ipaddress(fqdn)
    response = @client.request('facts', ['and', ['=', 'certname', fqdn], ['=', 'name', 'ipaddress']])
    response.data.map { |key| key['value'] }.first
  end
end
