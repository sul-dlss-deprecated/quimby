# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HoneybadgerClient do
  subject(:client) { described_class.new }

  describe '#initialize' do
    it 'creates an HoneybadgerClient instance' do
      expect(client).to be_an described_class
    end
  end

  describe '#all_projects_and_ids' do
    before do
      response = file_fixture('honeybadger_client_list_projects').read
      stub_request(:any, /app.honeybadger.io/).to_return(status: 200, body: response)
    end

    it 'returns a hash' do
      expect(client.all_projects_and_ids).to be_kind_of Hash
    end

    it 'returns an array for each key' do
      expect(client.all_projects_and_ids.first).to be_kind_of Array
    end

    it 'returns accurate project name and id' do
      expect(client.all_projects_and_ids.first).to eq ['Hello-World', 1]
    end
  end
end
