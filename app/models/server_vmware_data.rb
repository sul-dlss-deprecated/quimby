# frozen_string_literal: true

class ServerVmwareData
  attr_reader :connection

  def initialize
    @connection = VmwareClient.new
  end

  def self.run
    new.load_data
  end

  def load_data
    connection.list_of_vms_and_nets.each do |api_string|
      vm_and_net = api_string.split(',')
      server = Server.find_by(hostname: vm_and_net[0])
      next if server.nil? # vm not in puppetdb
      server.update(network: vm_and_net[1])
    end
  end
end
