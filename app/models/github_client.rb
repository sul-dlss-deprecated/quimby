# frozen_string_literal: true

require 'github_api'

class GithubClient
  attr_reader :api, :org

  def initialize(org)
    @api = Github.new do |c|
      c.auto_pagination = true
      c.oauth_token = Settings.GITHUB_OAUTH_TOKEN
      c.org = org
    end
    @org = org
  end

  def all_repos
    @repos ||= api.repos.all
  rescue Github::Error::NotFound
    NullResponse.new
  end

  def all_repo_names
    all_repos.map(&:name)
  end

  def repo_file_exists?(repo_name, path)
    get_repo_file_data(repo_name, path).present?
  end

  def repo_file_contains?(repo_name, path, search_string)
    file_data = get_repo_file_data repo_name, path
    decoded_file = decoded_file_content(file_data.content)
    content_contains?(decoded_file, search_string)
  end

  def list_files_at_path(repo_name, path)
    file_data = get_repo_file_data(repo_name, path)
    file_data.map(&:path)
  end

  def file_content(repo_name, path)
    file_data = get_repo_file_data repo_name, path
    decoded_file_content(file_data.content)
  end

  private

  def repo_contents_client
    @repo_contents ||= api.repos.contents user: org
  end

  def get_repo_file_data(repo_name, path)
    repo_contents_client.get repo: repo_name, path: path.to_s
  rescue Github::Error::NotFound
    NullResponse.new
  end

  def decoded_file_content(content)
    Base64.decode64(content)
  end

  def content_contains?(content, search_string)
    result = content.scan(/^[A-Za-z0-9\s]*[\'\"]#{search_string}[\'\"]/)
    return false if result.empty?
    true
  end
end
