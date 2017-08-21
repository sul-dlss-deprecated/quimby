# frozen_string_literal: true

FactoryGirl.define do
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
    gemnasium_alerts 3

    after(:create) do |repo|
      create(:first_dependency, repository: repo)
    end

    factory :repo_index_with_servers do
      after(:create) do |repo|
        repo.deploy_environments << create(:dev_deploy_environment)
      end
    end

    factory :repository_dependencies_index, class: Repository do
      name 'Hello-World-Test'
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

      after(:create) do |repo|
        create(:second_dependency, repository: repo)
      end
    end
  end
end
