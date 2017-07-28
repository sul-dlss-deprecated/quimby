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
    client.all_projects_and_counts.each do |slug, advisories|
      organization, name = slug.split('/')
      Repository.find_by(name: name, organization: organization).tap do |repo|
        repo&.update(gemnasium_alerts: advisories)
      end
    end
    true
  end
end
