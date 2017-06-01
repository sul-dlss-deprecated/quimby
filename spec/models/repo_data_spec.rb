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
      create(:repository)
      expect { basic_repo_data.load_basic_repo_data }.to change { Repository.all.count }.by 1
    end
  end

  describe '#load_data_fields_by_path' do
    describe 'with a valid reponse' do
      before do
        response = file_fixture('repo_contents_gemfile').read
        stub_request(:any, /api.github.com/).to_return(status: 200, body: response)
      end

      it 'sets field name to be true' do
        repo = create(:repository)
        expect do
          basic_repo_data.load_data_fields_by_path('Gemfile', :is_rails)
          repo.reload
        end.to change { repo.is_rails }.to be true
      end

      it 'loads and updates all Repository objects' do
        create_list(:repository, 10)
        basic_repo_data.load_data_fields_by_path('Gemfile', :is_rails)
        expect(Repository.all.all?(&:is_rails)).to be true
      end
    end

    describe 'with an exception thrown' do
      before do
        stub_request(:get, /api.github.com/).to_return(status: 404)
      end

      it 'sets field name to false' do
        repo = create(:repository)
        expect do
          basic_repo_data.load_data_fields_by_path('Otherfile', :is_rails)
          repo.reload
        end.to change { repo.is_rails }.to be false
      end
    end
  end
end
