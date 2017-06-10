# frozen_string_literal: true

class ServerHieraData
  attr_reader :client

  def initialize
    @client = GithubClient.new('sul-dlss')
  end

  def self.run
    new.load_data
  end

  def load_data
    hiera_filenames.map do |hiera|
      fqdn = strip_eyaml(hiera)
      hostname = strip_domain(fqdn)
      response = pupgraded?(hiera)
      Server.find_or_create_by(fqdn: fqdn).tap do |server|
        server.update(hostname: hostname, pupgraded: response)
      end
    end
    true
  end

  private

  def hiera_filenames
    client.list_files_at_path 'puppet', 'hieradata/node'
  end

  def pupgraded?(hiera_file)
    client.repo_file_contains? 'puppet', hiera_file, 'role::basenode'
  end

  def strip_eyaml(path)
    File.basename(path, '.eyaml')
  end

  def strip_domain(file)
    File.basename(file, '.stanford.edu')
  end
end
