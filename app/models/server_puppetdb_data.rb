# frozen_string_literal: true

class ServerPuppetdbData
  attr_reader :client

  def initialize
    @client = PuppetdbClient.new
  end

  def self.run
    new.load_data
  end

  def load_data
    client.all_fqdns.each do |fqdn|
      ip = client.ipaddress(fqdn)
      hostname = fqdn.split('.').first
      pupgraded = client.pupgraded?(fqdn)
      network = client.network(fqdn)
      Server.find_or_create_by(fqdn: fqdn).tap do |server|
        server.update(ip: ip, hostname: hostname,
                      pupgraded: pupgraded, network: network)
      end
    end
  end
end
