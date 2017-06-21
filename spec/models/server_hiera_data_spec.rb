# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ServerHieraData do
  subject(:server_data) { described_class.new }

  describe '#initialize' do
    it 'creates an GithubClient instance' do
      expect(server_data.client).to be_an GithubClient
    end

    it 'sets org to sul-dlss' do
      expect(server_data.client.api.org).to eq 'sul-dlss'
    end
  end

  describe '#load_data' do
    describe 'with pupgraded machine' do
      before do
        first = file_fixture('server_hiera_data_list_files').read
        second = file_fixture('server_hiera_data_file_contents').read
        stub_request(:any, /api.github.com/).to_return({ status: 200, body: first }, status: 200, body: second)
      end

      it 'creates one and only one new record' do
        expect { server_data.load_data }.to change { Server.all.count }.by 1
      end

      it 'loads hostname for Server objects' do
        server = create(:server, fqdn: 'somevm.stanford.edu')
        expect do
          server_data.load_data
          server.reload
        end.to change { server.hostname }.to eq 'somevm'
      end

      it 'sets pupgraded for Server objects' do
        server = create(:server, fqdn: 'somevm.stanford.edu')
        expect do
          server_data.load_data
          server.reload
        end.to change { server.pupgraded }.to eq true
      end
    end

    describe 'with not pupgraded machine' do
      before do
        first = file_fixture('server_hiera_data_list_files').read
        second = file_fixture('repo_data_get_file_contents').read
        stub_request(:any, /api.github.com/).to_return({ status: 200, body: first }, status: 200, body: second)
      end

      it 'sets pupgraded for Server objects' do
        server = create(:server, fqdn: 'somevm.stanford.edu')
        expect do
          server_data.load_data
          server.reload
        end.to change { server.pupgraded }.to eq false
      end
    end
  end
end
