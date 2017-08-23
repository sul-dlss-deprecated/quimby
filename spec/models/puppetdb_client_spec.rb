# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PuppetdbClient do
  subject(:client) { described_class.new }

  describe '#initialize' do
    it 'creates an PuppetdbClient instance' do
      expect(client).to be_an described_class
    end
  end

  describe '#ipaddress' do
    before do
      response = file_fixture('ipaddress_facts').read
      stub_request(:any, /puppetdb.example.com/).to_return(status: 200, body: response, headers: { 'Content-Type' => 'application/json' })
    end
    it 'returns the ipaddress of a server' do
      expect(client.ipaddress('some-server-stage.stanford.edu')).to eq '123.45.67.890'
    end
  end

  describe '#all_fqdns' do
    before do
      response = file_fixture('hostname_facts').read
      stub_request(:any, /puppetdb.example.com/).to_return(status: 200, body: response, headers: { 'Content-Type' => 'application/json' })
    end
    it 'returns all fqdns from the response' do
      expect(client.all_fqdns).to eq ['some-server-stage.stanford.edu', 'some-server-prod.stanford.edu']
    end
  end

  describe 'methods about pupgrading' do
    before do
      response = file_fixture('pupgrade_facts').read
      stub_request(:any, /puppetdb.example.com/).to_return(status: 200, body: response, headers: { 'Content-Type' => 'application/json' })
    end
    describe '#pupgraded_fqdns' do
      it 'returns fqdns of pupgraded machines' do
        expect(client.pupgraded_fqdns).to eq ['some-server-stage.stanford.edu', 'some-server-prod.stanford.edu']
      end
    end

    describe '#pupgraded?(fqdn)' do
      it 'says whether a machine is pupgraded or not' do
        expect(client.pupgraded?('some-server-stage.stanford.edu')).to be true
        expect(client.pupgraded?('not-pupgraded.stanford.edu')).to be false
      end
    end
  end

  describe '#network(fqdn)' do
    before do
      response = file_fixture('network_fact').read
      stub_request(:any, /puppetdb.example.com/).to_return(status: 200, body: response, headers: { 'Content-Type' => 'application/json' })
    end
    it 'returns the network zone of a node' do
      expect(client.network('some-server-stage.stanford.edu')).to eq 'stage'
    end
  end
end
