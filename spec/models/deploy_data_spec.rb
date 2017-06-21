# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeployData do
  subject(:deploy_data) { described_class.new('test-org') }

  describe '#initialize' do
    it 'creates an GithubClient instance' do
      expect(deploy_data.client).to be_an GithubClient
    end

    it 'sets org to test-org' do
      expect(deploy_data.client.api.org).to eq 'test-org'
    end
  end

  describe '#load_data' do
    describe 'with valid repo and server' do
      before do
        first = file_fixture('deploy_data_list_files').read
        second = file_fixture('deploy_data_file_contents').read
        stub_request(:any, /api.github.com/).to_return({ status: 200, body: first }, status: 200, body: second)
      end

      it 'creates a DeployEnvironment record' do
        create(:server, fqdn: 'argo-dev.stanford.edu')
        create(:repository, name: 'argo', has_capistrano: true)
        expect { deploy_data.load_data }.to change { DeployEnvironment.all.count }.by 1
      end

      it 'returns true rather than the DeployEnvironment object it creates' do
        expect(deploy_data.load_data).to eq true
      end
    end
  end
end
