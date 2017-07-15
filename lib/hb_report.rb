# frozen_string_literal: true

require 'csv'
CSV.open('hb_report.csv', 'wb') do |csv|
  csv << %w[repo has_honeybadger has_honeybadger_deploy]
  Repository.deployable.each do |repo|
    csv << [repo.name, repo.has_honeybadger, repo.has_honeybadger_deploy]
  end
end
