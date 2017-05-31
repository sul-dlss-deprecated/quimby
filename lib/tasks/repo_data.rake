# frozen_string_literal: true

namespace :load_repo_data do
  desc 'loads repo data for the sul-dlss org'
  task dlss: :environment do
    github_client = RepoData.new('sul-dlss')
    github_client.load_basic_repo_data
  end
end
