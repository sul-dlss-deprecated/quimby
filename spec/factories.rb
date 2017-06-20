# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    username 'testuser'
    password 'f4k3p455w0rd'
  end

  factory :repository do
    name 'Hello-World'
    organization 'octocat'

    factory :repo_with_servers do
      after(:create) do |repo|
        repo.deploy_environments << create(:dev_deploy_environment)
        repo.deploy_environments << create(:first_prod_deploy_environment)
        repo.deploy_environments << create(:second_prod_deploy_environment)
      end
    end
  end

  factory :repository_index, class: Repository do
    name 'Hello-World'
    organization 'octocat'
    url 'github.com'
    language 'ruby'
    is_rails 'true'
    is_gem 'true'
    has_capistrano 'true'
    has_honeybadger 'true'
    has_travis 'true'
    has_coveralls 'true'
    has_okcomputer 'true'
    has_is_it_working 'true'
  end

  factory :server do
  end

  factory :first_prod_server, class: Server do
    hostname 'server-prod-a'
    ip '123.45.67.890'
    dev_team 'devclub'
  end

  factory :second_prod_server, class: Server do
    hostname 'server-prod-b'
    ip '123.45.67.892'
    dev_team 'devclub'
  end

  factory :dev_server, class: Server do
    hostname 'server-dev'
    ip '123.45.67.891'
    dev_team 'devclub'
  end

  factory :first_prod_deploy_environment, class: DeployEnvironment do
    name 'prod'
    repository
    association :server, factory: :first_prod_server
  end

  factory :second_prod_deploy_environment, class: DeployEnvironment do
    name 'prod'
    repository
    association :server, factory: :second_prod_server
  end

  factory :dev_deploy_environment, class: DeployEnvironment do
    name 'dev'
    repository
    association :server, factory: :dev_server
  end
end
