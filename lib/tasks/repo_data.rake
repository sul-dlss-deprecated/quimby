# frozen_string_literal: true

namespace :load_repo_data do
  desc 'loads repo data for the sul-dlss org'
  task dlss: :environment do
    github_client = RepoData.new('sul-dlss')
    github_client.load_basic_repo_data
    github_client.load_data_fields_by_path 'Capfile', :has_capistrano
    github_client.load_data_fields_by_path '.rspec', :has_rspec
    github_client.load_data_fields_by_path '.travis.yml', :has_travis
    github_client.load_data_fields_by_path 'config/initializers/okcomputer.rb', :has_okcomputer
    github_client.load_data_fields_by_path 'config/initializers/is_it_working.rb', :has_is_it_working
    github_client.load_data_fields_by_file_content 'Gemfile', 'honeybadger', :has_honeybadger
  end
end
