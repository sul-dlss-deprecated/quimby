# frozen_string_literal: true

class RepoData
  attr_reader :client, :org

  def initialize(org)
    @client = GithubClient.new(org)
    @org = org
  end

  def self.run(org)
    new(org).load_data
  end

  # rubocop:disable Metrics/MethodLength
  def load_data
    client.all_repos.each do |r|
      Repository.find_or_create_by(name: r.name.downcase, organization: org) do |repo|
        repo.url = r.html_url
        repo.language = r.language
        repo.is_private = r.private
        repo.default_branch = r.default_branch
        repo.current = true
        load_file_based_data(repo)
      end
    end
    flag_deleted_repos
    true
  end
  # rubocop:enable Metrics/MethodLength

  private

  def load_file_based_data(repo)
    load_cap_data(repo)
    load_travis_data(repo)
    load_okcomputer_data(repo)
    load_is_it_working_data(repo)
    load_honeybadger_data(repo)
    load_coveralls_data(repo)
    load_rails_data(repo)
    load_honeybadger_deploy_data(repo)
    load_gem_data(repo)
  end

  def load_cap_data(repo)
    response = client.repo_file_exists? repo.name, 'Capfile'
    repo.has_capistrano = response
  end

  def load_travis_data(repo)
    response = client.repo_file_exists? repo.name, '.travis.yml'
    repo.has_travis = response
  end

  def load_okcomputer_data(repo)
    response = client.repo_file_exists? repo.name, 'config/initializers/okcomputer.rb'
    repo.has_okcomputer = response
  end

  def load_is_it_working_data(repo)
    response = client.repo_file_exists? repo.name, 'config/initializers/is_it_working.rb'
    repo.has_is_it_working = response
  end

  def load_honeybadger_data(repo)
    response = client.repo_file_contains? repo.name, 'Gemfile', 'honeybadger'
    repo.has_honeybadger = response
  end

  def load_coveralls_data(repo)
    response = client.repo_file_contains? repo.name, 'Gemfile', 'coveralls'
    repo.has_coveralls = response
  end

  def load_rails_data(repo)
    response = client.repo_file_contains? repo.name, 'Gemfile', 'rails'
    repo.is_rails = response
  end

  def load_honeybadger_deploy_data(repo)
    response = client.repo_file_contains? repo.name, 'Capfile', 'capistrano/honeybadger'
    repo.has_honeybadger_deploy = response
  end

  def load_gem_data(repo)
    response = client.list_files_at_path(repo.name, '/').grep(/gemspec/).any?
    repo.is_gem = response
  end

  def flag_deleted_repos
    db_repos = Repository.all.map(&:name)
    downcased_repos = client.all_repo_names.map(&:downcase)

    result = db_repos - downcased_repos
    result.each do |repo|
      record = Repository.find_by(name: repo)
      record.update(current: false)
    end
  end
end
