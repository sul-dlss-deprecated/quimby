# frozen_string_literal: true

namespace :load_repo_data do
  desc 'loads repo data for the sul-dlss org'
  task dlss: :environment do
    repodata = RepoData.new('sul-dlss')
    repodata.load_basic_repo_data
    repodata.load_capistrano_data
    repodata.load_rspec_data
    repodata.load_travis_data
    repodata.load_okcomputer_data
    repodata.load_is_it_working_data
    repodata.load_honeybadger_data
  end
end
