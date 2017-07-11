# frozen_string_literal: true

class ServerPuppetData
  attr_reader :client

  def initialize
    @client = PuppetdbClient.new(Settings.PUPPETDB_ENDPOINT)
  end

  def self.run
    new.load_data
  end

  def load_data
    Server.find_each do |server|
      server.update(ip: @client.ipaddress(server.fqdn))
    end
    true
  end
end
