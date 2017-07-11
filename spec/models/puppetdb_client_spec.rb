# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PuppetdbClient do
  subject(:client) { described_class.new('http://sulpuppet-db.stanford.edu:8080') }

  describe '#initialize' do
    it 'creates an PuppetdbClient instance' do
      expect(client).to be_an described_class
    end
  end

  describe '#ipaddress' do
    before do
      response = file_fixture('puppetdb_fact').read
      stub_request(:any, /sulpuppet-db.stanford.edu/).to_return(status: 200, body: response, headers: { 'Content-Type' => 'application/json' })
    end

    it 'returns the ipaddress of a server' do
      expect(client.ipaddress('some-server-stage.stanford.edu')).to eq '123.45.67.890'
    end
  end
end
