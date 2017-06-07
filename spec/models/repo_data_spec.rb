# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RepoData do
  subject(:repo_data) { described_class.new('octocat') }

  describe '#initialize' do
    it 'creates an GithubClient instance' do
      expect(repo_data.client).to be_an GithubClient
    end
  end

  describe '#load_basic_repo_data' do
    before do
      response = file_fixture('all_repos').read
      stub_request(:any, /api.github.com/).to_return(status: 200, body: response)
    end

    it 'creates objects from api response' do
      repo = repo_data.load_basic_repo_data.first
      expect(repo.name).to eq 'Hello-World'
      expect(repo.organization).to eq 'octocat'
      expect(repo.url).to eq 'https://github.com/octocat/Hello-World'
      expect(repo.language).to eq 'ruby'
    end

    it 'only creates unique objects on name and organization' do
      create(:repository)
      expect { repo_data.load_basic_repo_data }.to change { Repository.all.count }.by 1
    end
  end

  describe '#load_capistrano_data' do
    describe 'with valid response' do
      before do
        response = file_fixture('repo_data_get_file').read
        stub_request(:any, /api.github.com/).to_return(status: 200, body: response)
      end

      it 'sets capistrano field to true' do
        repo = create(:repository)
        expect do
          repo_data.load_capistrano_data
          repo.reload
        end.to change { repo.has_capistrano }.to be true
      end
    end

    describe 'with invalid response' do
      before do
        stub_request(:any, /api.github.com/).to_return(status: 404)
      end

      it 'sets capistrano field to false' do
        repo = create(:repository)
        expect do
          repo_data.load_capistrano_data
          repo.reload
        end.to change { repo.has_capistrano }.to be false
      end
    end
  end

  describe '#load_travis_data' do
    describe 'with valid response' do
      before do
        response = file_fixture('repo_data_get_file').read
        stub_request(:any, /api.github.com/).to_return(status: 200, body: response)
      end

      it 'sets travis field to true' do
        repo = create(:repository)
        expect do
          repo_data.load_travis_data
          repo.reload
        end.to change { repo.has_travis }.to be true
      end
    end

    describe 'with invalid response' do
      before do
        stub_request(:any, /api.github.com/).to_return(status: 404)
      end

      it 'sets travis field to false' do
        repo = create(:repository)
        expect do
          repo_data.load_travis_data
          repo.reload
        end.to change { repo.has_travis }.to be false
      end
    end
  end

  describe '#load_okcomputer_data' do
    describe 'with valid response' do
      before do
        response = file_fixture('repo_data_get_file').read
        stub_request(:any, /api.github.com/).to_return(status: 200, body: response)
      end

      it 'sets okcomputer field to true' do
        repo = create(:repository)
        expect do
          repo_data.load_okcomputer_data
          repo.reload
        end.to change { repo.has_okcomputer }.to be true
      end
    end

    describe 'with invalid response' do
      before do
        stub_request(:any, /api.github.com/).to_return(status: 404)
      end

      it 'sets okcomputer field to false' do
        repo = create(:repository)
        expect do
          repo_data.load_okcomputer_data
          repo.reload
        end.to change { repo.has_okcomputer }.to be false
      end
    end
  end

  describe '#load_is_it_working_data' do
    describe 'with valid response' do
      before do
        response = file_fixture('repo_data_get_file').read
        stub_request(:any, /api.github.com/).to_return(status: 200, body: response)
      end

      it 'sets is_it_working field to true' do
        repo = create(:repository)
        expect do
          repo_data.load_is_it_working_data
          repo.reload
        end.to change { repo.has_is_it_working }.to be true
      end
    end

    describe 'with invalid response' do
      before do
        stub_request(:any, /api.github.com/).to_return(status: 404)
      end

      it 'sets is_it_working field to false' do
        repo = create(:repository)
        expect do
          repo_data.load_is_it_working_data
          repo.reload
        end.to change { repo.has_is_it_working }.to be false
      end
    end
  end

  describe '#load_honeybadger_data' do
    describe 'with a valid reponse' do
      before do
        response = file_fixture('repo_data_get_file_contents').read
        stub_request(:any, /api.github.com/).to_return(status: 200, body: response)
      end

      it 'sets field name to be true' do
        repo = create(:repository)
        expect do
          repo_data.load_honeybadger_data
          repo.reload
        end.to change { repo.has_honeybadger }.to be true
      end
    end

    describe 'with an exception thrown' do
      before do
        stub_request(:any, /api.github.com/).to_return(status: 404)
      end

      it 'sets field name to false' do
        repo = create(:repository)
        expect do
          repo_data.load_honeybadger_data
          repo.reload
        end.to change { repo.has_honeybadger }.to be false
      end
    end
  end

  describe '#load_coveralls_data' do
    describe 'with a valid response' do
      before do
        response = file_fixture('repo_data_get_file_contents').read
        stub_request(:any, /api.github.com/).to_return(status: 200, body: response)
      end

      it 'sets the field name to be true' do
        repo = create(:repository)
        expect do
          repo_data.load_coveralls_data
          repo.reload
        end.to change { repo.has_coveralls }.to be true
      end
    end

    describe 'with an exception thrown' do
      before do
        stub_request(:any, /api.github.com/).to_return(status: 404)
      end

      it 'sets the field name to false' do
        repo = create(:repository)
        expect do
          repo_data.load_coveralls_data
          repo.reload
        end.to change { repo.has_coveralls }.to be false
      end
    end
  end

  describe '#load_gem_data' do
    describe 'with a valid response' do
      before do
        response = file_fixture('repo_data_list_files').read
        stub_request(:any, /api.github.com/).to_return(status: 200, body: response)
      end

      it 'sets is_gem field to true' do
        repo = create(:repository)
        expect do
          repo_data.load_gem_data
          repo.reload
        end.to change { repo.is_gem }.to be true
      end
    end

    describe 'with an exception thrown' do
      before do
        stub_request(:any, /api.github.com/).to_return(status: 404)
      end

      it 'sets is_gem field to false' do
        repo = create(:repository)
        expect do
          repo_data.load_gem_data
          repo.reload
        end.to change { repo.is_gem }.to be false
      end
    end
  end

  describe '#load_rails_data' do
    describe 'with a valid reponse' do
      before do
        response = file_fixture('repo_data_get_file_contents').read
        stub_request(:any, /api.github.com/).to_return(status: 200, body: response)
      end

      it 'sets field name to be true' do
        repo = create(:repository)
        expect do
          repo_data.load_rails_data
          repo.reload
        end.to change { repo.is_rails }.to be true
      end
    end

    describe 'with an exception thrown' do
      before do
        stub_request(:any, /api.github.com/).to_return(status: 404)
      end

      it 'sets field name to false' do
        repo = create(:repository)
        expect do
          repo_data.load_rails_data
          repo.reload
        end.to change { repo.is_rails }.to be false
      end
    end
  end

  describe 'each load_xx_data method should change all records' do
    describe 'based on repo_file_exists?' do
      before do
        response = file_fixture('repo_data_get_file').read
        stub_request(:any, /api.github.com/).to_return(status: 200, body: response)
      end

      it 'for load_capistrano_data' do
        create_list(:repository, 10)
        repo_data.load_capistrano_data
        expect(Repository.all.all?(&:has_capistrano)).to be true
      end

      it 'for load_travis_data' do
        create_list(:repository, 10)
        repo_data.load_travis_data
        expect(Repository.all.all?(&:has_travis)).to be true
      end

      it 'for load_okcomputer_data' do
        create_list(:repository, 10)
        repo_data.load_okcomputer_data
        expect(Repository.all.all?(&:has_okcomputer)).to be true
      end

      it 'for load_is_it_working_data' do
        create_list(:repository, 10)
        repo_data.load_is_it_working_data
        expect(Repository.all.all?(&:has_is_it_working)).to be true
      end
    end

    describe 'based on list_directory_contents' do
      before do
        response = file_fixture('repo_data_list_files').read
        stub_request(:any, /api.github.com/).to_return(status: 200, body: response)
      end

      it 'for load_gem_data' do
        create_list(:repository, 10)
        repo_data.load_gem_data
        expect(Repository.all.all?(&:is_gem)).to be true
      end
    end

    describe 'based on repo_file_contains?' do
      before do
        response = file_fixture('repo_data_get_file_contents').read
        stub_request(:any, /api.github.com/).to_return(status: 200, body: response)
      end

      it 'for load_honeybadger_data' do
        create_list(:repository, 10)
        repo_data.load_honeybadger_data
        expect(Repository.all.all?(&:has_honeybadger)).to be true
      end

      it 'for load_coveralls_data' do
        create_list(:repository, 10)
        repo_data.load_coveralls_data
        expect(Repository.all.all?(&:has_coveralls)).to be true
      end

      it 'for load_rails_data' do
        create_list(:repository, 10)
        repo_data.load_rails_data
        expect(Repository.all.all?(&:is_rails)).to be true
      end
    end
  end
end
