# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GithubClient do
  subject(:client) { described_class.new('test-org') }

  describe '#initialize' do
    it 'creates an Github::Client instance' do
      expect(client.api).to be_an Github::Client
    end

    it 'sets the clients user to the passed org' do
      expect(client.api.org).to eq 'test-org'
    end
  end

  describe '#all_repos' do
    before do
      response = file_fixture('all_repos').read
      stub_request(:any, /api.github.com/).to_return(status: 200, body: response)
    end

    it 'creates an Github::ResponseWrapper instance' do
      expect(client.all_repos).to be_an Github::ResponseWrapper
    end

    it 'responds to .map as an Enumerable' do
      expect(client.all_repos.map).to be_kind_of Enumerable
    end
  end

  describe '#all_repo_names' do
    before do
      response = file_fixture('all_repos').read
      stub_request(:any, /api.github.com/).to_return(status: 200, body: response)
    end

    it 'returns all repo names as an array' do
      expect(client.all_repo_names).to eq ['Hello-World', 'Hello-World2']
    end
  end

  describe '#repo_file_exists?' do
    describe 'with valid response' do
      before do
        response = file_fixture('repo_data_get_file').read
        stub_request(:any, /api.github.com/).to_return(status: 200, body: response)
      end

      it 'returns true' do
        expect(client.repo_file_exists?('fake', 'response')).to be true
      end
    end

    describe 'with invalid response' do
      before do
        response = file_fixture('repo_data_get_file').read
        stub_request(:any, /api.github.com/).to_return(status: 404, body: response)
      end

      it 'returns true' do
        expect(client.repo_file_exists?('fake', 'response')).to be false
      end
    end
  end

  describe '#repo_file_contains?' do
    describe 'with valid response' do
      before do
        response = file_fixture('repo_data_get_file_contents').read
        stub_request(:any, /api.github.com/).to_return(status: 200, body: response)
      end

      it 'returns true' do
        expect(client.repo_file_contains?('fake', 'Gemfile', 'rails')).to be true
      end
    end

    describe 'with invalid response' do
      before do
        response = file_fixture('repo_data_get_file').read
        stub_request(:any, /api.github.com/).to_return(status: 404, body: response)
      end

      it 'returns true' do
        expect(client.repo_file_contains?('fake', 'Gemfile', 'rails')).to be false
      end
    end
  end

  describe '#list_files_at_path' do
    describe 'with valid response' do
      before do
        response = file_fixture('repo_data_list_files').read
        stub_request(:any, /api.github.com/).to_return(status: 200, body: response)
      end

      it 'returns array of filenames' do
        expect(client.list_files_at_path('fake', '/')).to eq ['octokit.rb', 'octokitty', 'octokit.gemspec']
      end
    end

    describe 'with invalid response' do
      before do
        response = file_fixture('repo_data_list_files').read
        stub_request(:any, /api.github.com/).to_return(status: 404, body: response)
      end

      it 'returns empty array if path invalid' do
        expect(client.list_files_at_path('fake', '/test')).to eq []
      end
    end
  end

  describe '#file_content' do
    describe 'with valid response' do
      before do
        response = file_fixture('repo_data_get_file_contents').read
        stub_request(:any, /api.github.com/).to_return(status: 200, body: response)
      end

      it 'returns text blob' do
        expect(client.file_content('fake', 'Gemfile')).to include 'rubygems.org'
      end
    end

    describe 'with invalid response' do
      before do
        response = file_fixture('repo_data_get_file_contents').read
        stub_request(:any, /api.github.com/).to_return(status: 404, body: response)
      end

      it 'returns empty string if path invalid' do
        expect(client.file_content('fake', 'test')).to eq ''
      end
    end
  end
end
