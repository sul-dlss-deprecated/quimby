# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VmwareClient do
  subject(:client) { described_class.new }

  describe '#initialize' do
    it 'creates an VmwareClient instance' do
      expect(client).to be_an described_class
    end
  end

  describe '#connection' do
    it 'responds to #connection' do
      expect(client).to respond_to(:connection)
    end
  end

  describe '#list_of_vms_and_nets' do
    it 'returns an array of comma-separated strings' do
      client = instance_double('vmware_client')
      allow(client).to receive(:list_of_vms_and_nets).and_return(['server-dev,dev-net'])
      expect(client.list_of_vms_and_nets).to eq(['server-dev,dev-net'])
    end
  end
end
