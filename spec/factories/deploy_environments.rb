# frozen_string_literal: true

FactoryGirl.define do
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
