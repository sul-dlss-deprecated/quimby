# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository, type: :model do
  it { is_expected.to have_many(:deploy_environments) }
  it { is_expected.to have_many(:servers).through(:deploy_environments) }

  let(:repo) { create(:repo_with_servers) }

  describe '#unique_deploy_envs' do
    it 'returns an array' do
      expect(repo.unique_deploy_envs).to be_kind_of Array
    end

    it 'de-dups deploy_environments' do
      expect(repo.unique_deploy_envs).to eq %w[dev prod]
    end
  end

  describe '#servers_deployed_to(env)' do
    it 'returns all servers deployed in an environment' do
      expect(repo.servers_deployed_to('prod')).to eq %w[server-prod-a server-prod-b]
      expect(repo.servers_deployed_to('dev')).to eq %w[server-dev]
    end
  end
end
