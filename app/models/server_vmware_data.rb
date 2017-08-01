# frozen_string_literal: true

class ServerVmwareData
  attr_reader :connection

  def initialize
    @connection = VmwareClient.new
  end

  def self.run
    new.load_data
  end

  # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
  def load_data
    connection.view_all_vms.each do |vm|
      server = Server.find_by(hostname: vm.name)
      next if server.nil? # vm not in puppetdb
      networks = []
      vm.config.hardware.device.each do |device|
        next unless Server.nic_types.include?(device.class.to_s)
        networks << device.deviceInfo.summary
        foz_net = networks.grep(/FOZ/).first
        server.update(network: foz_net)
      end
    end
    connection.client.close
  end
  # rubocop:enable Metrics/MethodLength,Metrics/AbcSize
end
