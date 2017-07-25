# frozen_string_literal: true

require 'rails_helper'
require 'ipaddr'

RSpec.describe ServerPuppetdbData do
  subject(:server_puppetdb_data) { described_class.new }

  describe '#initialize' do
    it 'creates an PuppetdbClient instance' do
      expect(server_puppetdb_data.client).to be_an PuppetdbClient
    end
  end

  describe '#load_data' do
    describe 'with valid response' do
      before do
        hostname_facts = file_fixture('hostname_facts').read
        ipaddress_facts = file_fixture('ipaddress_facts').read
        stub_request(:any, /puppetdb.example.com/).to_return(status: 200, body: hostname_facts, headers: { 'Content-Type' => 'application/json' }).then
                                                  .to_return(status: 200, body: ipaddress_facts, headers: { 'Content-Type' => 'application/json' })
      end

      it 'creates objects from api response' do
        server_puppetdb_data.load_data
        server = Server.first
        expect(server.fqdn).to eq 'some-server-stage.stanford.edu'
        expect(server.hostname).to eq 'some-server-stage'
        expect(server.ip).to eq '123.45.67.890'
        expect(server.pupgraded).to be true
      end

      it 'only creates unique objects' do
        create(:server)
        expect { server_puppetdb_data.load_data }.to change { Server.all.count }.by 2
      end
    end

    describe 'with empty puppetdb response' do
      before do
        stub_request(:any, /puppetdb.example.com/).to_return(status: 200, body: '[]', headers: { 'Content-Type' => 'application/json' }).then
                                                  .to_return(status: 200, body: '[]', headers: { 'Content-Type' => 'application/json' })
      end

      it 'does not create a Server' do
        server_puppetdb_data.load_data
        expect { server_puppetdb_data.load_data }.to change { Server.all.count }.by 0
      end
    end
  end
end
