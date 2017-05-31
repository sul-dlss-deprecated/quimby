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

  private

  def all_repos
    @repos ||= github_client.repos.all
  end
end
