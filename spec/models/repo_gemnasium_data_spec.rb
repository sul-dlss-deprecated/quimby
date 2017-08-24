# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RepoGemnasiumData do
  subject(:repo_gemnasium_data) { described_class.new }

  describe '#initialize' do
    it 'creates an RepoGemnasiumData instance' do
      expect(repo_gemnasium_data.client).to be_an GemnasiumClient
    end
  end

  describe '#load_data' do
    before do
      projects = file_fixture('gemnasium_client_list_projects').read
      alerts_hw = file_fixture('gemnasium_client_list_alerts_hello_world').read
      alerts_hwc = file_fixture('gemnasium_client_list_alerts_hello_world_clean').read
      alerts_hwt = file_fixture('gemnasium_client_list_alerts_hello_world_test').read
      deps_hw = file_fixture('gemnasium_client_list_dependencies_hello_world').read
      deps_hwc = file_fixture('gemnasium_client_list_dependencies_hello_world_clean').read
      stub_request(:any, 'https://api.gemnasium.com/v1/projects').to_return(status: 200, body: projects)
      stub_request(:any, 'https://api.gemnasium.com/v1/projects/sul-dlss/hello-world/alerts').to_return(status: 200, body: alerts_hw)
      stub_request(:any, 'https://api.gemnasium.com/v1/projects/sul-dlss/hello-world-clean/alerts').to_return(status: 200, body: alerts_hwc)
      stub_request(:any, 'https://api.gemnasium.com/v1/projects/sul-dlss/hello-world-test/alerts').to_return(status: 200, body: alerts_hwt)
      stub_request(:any, 'https://api.gemnasium.com/v1/projects/sul-dlss/hello-world/dependencies').to_return(status: 200, body: deps_hw)
      stub_request(:any, 'https://api.gemnasium.com/v1/projects/sul-dlss/hello-world-clean/dependencies').to_return(status: 200, body: deps_hwc)
      stub_request(:any, 'https://api.gemnasium.com/v1/projects/sul-dlss/hello-world-test/dependencies').to_return(status: 200, body: deps_hwc)
    end

    it 'returns true' do
      expect(repo_gemnasium_data.load_data).to eq true
    end

    it 'sets gemnasium count on matching repos' do
      repo = create(:repository, name: 'hello-world', organization: 'sul-dlss')
      expect do
        repo_gemnasium_data.load_data
        repo.reload
      end.to change { repo.gemnasium_alerts }.to eq 2
    end

    it 'sets dependencies on matching repos' do
      repo = create(:repository, name: 'hello-world', organization: 'sul-dlss')
      repo_gemnasium_data.load_data
      repo.reload
      expect(repo.dependencies.count).to eq 2
      expect(repo.dependencies.first.name).to eq 'lyberteam-devel'
      expect(repo.dependencies.second.name).to eq 'mediashelf-loggable'
    end

    it 'sets gemnasium count on matching repos without alerts' do
      repo = create(:repository, name: 'hello-world-clean', organization: 'sul-dlss')
      expect do
        repo_gemnasium_data.load_data
        repo.reload
      end.to change { repo.gemnasium_alerts }.to eq 0
    end

    it 'skips unmatched repos' do
      repo = create(:repository, name: 'hello-world-test2', organization: 'sul-dlss')
      expect do
        repo_gemnasium_data.load_data
        repo.reload
      end.not_to change(repo, :gemnasium_alerts)
    end
  end
end
