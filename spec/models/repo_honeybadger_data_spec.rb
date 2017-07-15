# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RepoHoneybadgerData do
  subject(:repo_hb_data) { described_class.new }

  describe '#initialize' do
    it 'creates an RepoHoneybadgerData instance' do
      expect(repo_hb_data.client).to be_an HoneybadgerClient
    end
  end

  describe '#load_data' do
    before do
      response = file_fixture('honeybadger_client_list_projects').read
      stub_request(:any, /app.honeybadger.io/).to_return(status: 200, body: response)
    end

    it 'returns true' do
      expect(repo_hb_data.load_data).to eq true
    end

    it 'sets honeybadger id on matching repos' do
      repo = create(:repository, name: 'hello-world')
      expect do
        repo_hb_data.load_data
        repo.reload
      end.to change { repo.honeybadger_id }.to eq 1
    end

    it 'skips unmatched repos' do
      repo = create(:repository, name: 'hello-world-test')
      expect do
        repo_hb_data.load_data
        repo.reload
      end.not_to change(repo, :honeybadger_id)
    end
  end
end
