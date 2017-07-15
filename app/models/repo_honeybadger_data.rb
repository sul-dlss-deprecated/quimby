# frozen_string_literal: true

class RepoHoneybadgerData
  attr_reader :client

  def initialize
    @client = HoneybadgerClient.new
  end

  def self.run
    new.load_data
  end

  def load_data
    client.all_projects_and_ids.each do |name, id|
      Repository.find_by(name: name.downcase).tap do |repo|
        repo&.update(honeybadger_id: id)
      end
    end
    true
  end
end
