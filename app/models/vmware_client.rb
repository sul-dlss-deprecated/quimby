# frozen_string_literal: true

class VmwareClient
  attr_reader :connection, :config

  def initialize(debug: false)
    @config = {
      host: Settings.VMWARE_API_HOST,
      user: Settings.VMWARE_API_USER,
      password: Settings.VMWARE_API_PASSWORD,
      insecure: true,
      debug: debug
    }
  end

  def connection
    @connection ||= RbVmomi::VIM.connect(config)
  end

  # rubocop:disable MethodLength,Metrics/AbcSize
  def list_of_vms_and_nets
    vms = connection.serviceContent.viewManager.CreateContainerView(container: connection.rootFolder,
                                                                    type: ['VirtualMachine'],
                                                                    recursive: true).view
    vms_and_nets = []
    vms.each do |vm|
      nets = []
      vm.config.hardware.device.each do |device|
        next unless Server.nic_types.include?(device.class.to_s)
        nets << device.deviceInfo.summary
        foz_net = nets.grep(/FOZ/).first
        vms_and_nets << "#{vm.name},#{foz_net}"
      end
    end
    connection.close
    vms_and_nets
  end
  # rubocop:enable MethodLength,Metrics/AbcSize
end
