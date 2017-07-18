# frozen_string_literal: true

namespace :load_data do
  desc 'loads server data from puppet and puppet\'s hiera files'
  task servers: :environment do
    ServerPuppetData.run
  end

  desc 'loads repo data for the sul-dlss org'
  task dlss: :environment do
    org = 'sul-dlss'
    RepoData.run(org)
    DeployData.run(org)
  end

  desc 'loads repo data for the sul-cidr org'
  task cidr: :environment do
    org = 'sul-cidr'
    RepoData.run(org)
    DeployData.run(org)
  end

  desc 'loads it all'
  task all: :environment do
    Rake::Task['load_data:servers'].invoke
    Rake::Task['load_data:dlss'].invoke
    Rake::Task['load_data:cidr'].invoke
  end
end
