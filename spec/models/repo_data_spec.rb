# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RepoData do
  subject(:basic_repo_data) { described_class.new('test-org') }

  describe '#initialize' do
    it 'creates an github_client instance' do
      expect(basic_repo_data.github_client).to be_an Github::Client
    end

    it 'sets the clients user to the passed org' do
      expect(basic_repo_data.github_client.user).to eq 'test-org'
    end
  end

  describe '#load_basic_repo_data' do
    before do
      response = file_fixture('all_repos').read
      stub_request(:any, /api.github.com/).to_return(status: 200, body: response)
    end

    it 'creates objects from api response' do
      repo = basic_repo_data.load_basic_repo_data.first
      expect(repo.name).to eq 'Hello-World'
      expect(repo.organization).to eq 'octocat'
      expect(repo.url).to eq 'https://github.com/octocat/Hello-World'
      expect(repo.language).to eq 'ruby'
    end

    it 'only creates unique objects on name and organization' do
      Repository.create(name: 'Hello-World', organization: 'octocat')
      expect { basic_repo_data.load_basic_repo_data }.to change { Repository.all.count }.by 1
    end
  end
end
