# frozen_string_literal: true

namespace :load_data do
  desc 'loads server data from puppetdb and vmware'
  task servers: :environment do
    ServerPuppetdbData.run
    ServerVmwareData.run
  end

  desc 'loads repo data for the sul-dlss org'
  task dlss: :servers do
    org = 'sul-dlss'
    RepoData.run(org)
    DeployData.run(org)
  end

  desc 'loads repo data for the sul-cidr org'
  task cidr: :dlss do
    org = 'sul-cidr'
    RepoData.run(org)
    DeployData.run(org)
  end

  desc 'loads from all data sources in order'
  task all: %i[environment servers dlss cidr]
end
