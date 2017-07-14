# frozen_string_literal: true

require 'honeybadger-api'

class HoneybadgerClient
  def initialize
    Honeybadger::Api.configure do |c|
      c.access_token = Settings.HONEYBADGER_API_TOKEN
    end
  end

  def all_projects_and_ids
    projects_and_ids = {}
    all_projects.each do |project|
      projects_and_ids[project.name] = project.id
    end
    projects_and_ids
  end

  private

  def all_projects
    @projects ||= Honeybadger::Api::Project.all
  end
end
