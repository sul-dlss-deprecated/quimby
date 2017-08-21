# frozen_string_literal: true

class RepoGemnasiumData
  attr_reader :client

  def initialize
    @client = GemnasiumClient.new
  end

  def self.run
    new.load_data
  end

  def load_data
    load_alerts
    load_dependencies
    true
  end

  private

  def load_alerts
    client.all_projects_and_counts.each do |slug, advisories|
      organization, name = slug.split('/')
      Repository.find_by(name: name, organization: organization).tap do |repo|
        repo&.update(gemnasium_alerts: advisories)
      end
    end
  end

  def load_dependencies
    client.all_dependencies.each do |slug, dependencies|
      deps = dependencies.map do |d|
        Dependency.new(name: d['name'], version: d['version'])
      end
      organization, name = slug.split('/')
      Repository.find_by(name: name, organization: organization).tap do |repo|
        repo&.dependencies&.replace(deps)
      end
    end
  end
end
