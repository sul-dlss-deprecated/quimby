# frozen_string_literal: true

require 'json'
require 'rest-client'
require 'timeout'

class GemnasiumClient
  attr_reader :api

  def initialize
    api_key = Settings.GEMNASIUM_API_TOKEN
    @api = "https://X:#{api_key}@api.gemnasium.com/v1"
  end

  def all_projects_and_counts
    advisories = {}
    all_projects.each do |slug|
      alerts = fetch_api("#{api}/projects/#{slug}/alerts")
      advisories[slug] = alerts.count
    end
    advisories
  end

  def all_dependencies
    gems = {}
    all_projects.each do |slug|
      gems[slug] = []

      fetch_api("#{api}/projects/#{slug}/dependencies").each do |gem|
        next unless gem['package']['type'] == 'Rubygem'
        dep = { name: gem['package']['name'], version: gem['locked'] }
        gems[slug].push(dep)
      end
    end
    gems
  end

  private

  def all_projects
    slugs = []
    url = "#{api}/projects"
    projects = fetch_api(url)
    projects['owned'].each do |project|
      next unless project['monitored']
      slugs.push(project['slug'])
    end
    slugs
  end

  # rubocop:disable MethodLength
  def fetch_api(url)
    attempts = 0
    data = {}
    success = false
    while attempts <= 3
      begin
        Timeout.timeout(30) do
          data = JSON.parse(RestClient.get(url, method: 'get',
                                                ssl_verion: 'TLSv1',
                                                ssl_ciphers: ['RC4-SHA']))
          success = true
        end
      rescue Timeout::Error, Net::HTTPRetriableError, OpenSSL::SSL::SSLError, RestClient::SSLCertificateNotVerified
        sleep(10)
      end
      break if success
      attempts += 1
    end
    data
  end
  # rubocop:enable MethodLength
end
