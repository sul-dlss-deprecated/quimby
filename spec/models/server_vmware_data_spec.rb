# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ServerVmwareData do
  subject(:server_vmware_data) { described_class.new }

  describe '#initialize' do
    it 'creates an VmwareClient instance' do
      expect(server_vmware_data.connection).to be_an VmwareClient
    end
  end
end
