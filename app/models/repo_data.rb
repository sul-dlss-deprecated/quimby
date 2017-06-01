# frozen_string_literal: true

require 'github_api'

class RepoData
  attr_reader :github_client

  def initialize(org)
    @github_client = Github.new do |c|
      c.auto_pagination = true
      c.oauth_token = Settings.GITHUB_OAUTH_TOKEN
      c.user = org
    end
  end

  def load_basic_repo_data
    all_repos.map do |r|
      Repository.find_or_create_by(name: r.name, organization: r.owner.login) do |repo|
        repo.url = r.html_url
        repo.language = r.language
      end
    end
  end

  def load_data_fields_by_path(path, field_name)
    Repository.find_each do |r|
      response = repo_file_exists? r.name, path
      r.update(field_name => response)
    end
  end

  private

  def all_repos
    @repos ||= github_client.repos.all
  end

  def repo_contents
    @repo_contents ||= github_client.repos.contents
  end

  def get_repo_contents(repo_name, path)
    repo_contents.get repo: repo_name, path: path.to_s
  rescue Github::Error::NotFound
    NullResponse.new
  end

  def repo_file_exists?(repo_name, path)
    return true if get_repo_contents(repo_name, path).present?
    false
  end
end
