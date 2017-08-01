# frozen_string_literal: true

class VmwareClient
  attr_reader :client

  def initialize
    @client = RbVmomi::VIM.connect(host: Settings.VMWARE_API_HOST,
                                   user: Settings.VMWARE_API_USER,
                                   password: Settings.VMWARE_API_PASSWORD,
                                   insecure: true)
  end

  def view_all_vms
    client.serviceContent.viewManager.CreateContainerView(container: client.rootFolder,
                                                          type: ['VirtualMachine'],
                                                          recursive: true).view
  end
end
