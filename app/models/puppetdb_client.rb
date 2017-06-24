# frozen_string_literal: true

require 'puppetdb'

class PuppetdbClient
  attr_reader :client

  def initialize
    @client = PuppetDB::Client.new(server: Settings.PUPPETDB_ENDPOINT)
  end

  def ipaddress(fqdn)
    # once we are on facter v. 3, we will have access to
    # the structured 'networking' fact which could be valuable
    response = client.request('facts', ['and', ['=', 'certname', fqdn], ['=', 'name', 'ipaddress']])
    response.data.first['value']
  end
end
