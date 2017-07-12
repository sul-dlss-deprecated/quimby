# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RepoData do
  subject(:repo_data) { described_class.new('octocat') }

  describe '#initialize' do
    it 'creates an GithubClient instance' do
      expect(repo_data.client).to be_an GithubClient
    end

    it 'set org on GithubClient' do
      expect(repo_data.org).to eq 'octocat'
    end
  end

  describe '#load_data' do
    describe 'with valid response' do
      before do
        allrepos = file_fixture('all_repos').read
        gemfile = file_fixture('repo_data_get_file_contents').read
        capfile = file_fixture('repo_data_get_capfile_contents').read
        list_files = file_fixture('repo_data_list_files').read
        stub_request(:any, /api.github.com/)
          .to_return(status: 200, body: allrepos).then
          .to_return(status: 200, body: gemfile).times(7).then
          .to_return(status: 200, body: capfile).then
          .to_return(status: 200, body: list_files)
      end

      it 'creates objects from api response' do
        repo_data.load_data
        repo = Repository.last
        expect(repo.name).to eq 'Hello-World2'
        expect(repo.organization).to eq 'octocat'
        expect(repo.url).to eq 'https://github.com/octocat/Hello-World2'
        expect(repo.language).to eq 'java'
        expect(repo.is_private).to be true
        expect(repo.default_branch).to eq 'add-feature'
        expect(repo.has_capistrano).to be true
        expect(repo.has_travis).to be true
        expect(repo.has_honeybadger).to be true
        expect(repo.has_okcomputer).to be true
        expect(repo.has_is_it_working).to be true
        expect(repo.has_coveralls).to be true
        expect(repo.is_rails).to be true
        expect(repo.has_honeybadger_deploy).to be true
        expect(repo.is_gem).to be true
      end

      it 'only creates unique objects on name and organization' do
        create(:repository)
        expect { repo_data.load_data }.to change { Repository.all.count }.by 1
      end
    end

    describe 'with invalid response' do
      before do
        response = file_fixture('repo_data_get_file').read
        stub_request(:any, /api.github.com/).to_return(status: 404, body: response)
      end

      it 'does not create a Repository object' do
        repo_data.load_data
        expect { repo_data.load_data }.to change { Repository.all.count }.by 0
      end
    end

    describe 'with invalid response' do
      before do
        response = file_fixture('all_repos').read
        stub_request(:any, /api.github.com/)
          .to_return(status: 200, body: response).then
          .to_return(status: 404, body: response).times(8)
      end

      it 'no Repository object created' do
        repo_data.load_data
        repo = Repository.last
        expect(repo.name).to eq 'Hello-World2'
        expect(repo.organization).to eq 'octocat'
        expect(repo.url).to eq 'https://github.com/octocat/Hello-World2'
        expect(repo.language).to eq 'java'
        expect(repo.is_private).to be true
        expect(repo.default_branch).to eq 'add-feature'
        expect(repo.has_capistrano).to be false
        expect(repo.has_travis).to be false
        expect(repo.has_honeybadger).to be false
        expect(repo.has_okcomputer).to be false
        expect(repo.has_is_it_working).to be false
        expect(repo.has_coveralls).to be false
        expect(repo.is_rails).to be false
        expect(repo.is_gem).to be false
      end
    end
  end
end
