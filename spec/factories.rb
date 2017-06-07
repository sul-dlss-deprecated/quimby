# frozen_string_literal: true

FactoryGirl.define do
  factory :repository do
    name 'Hello-World'
    organization 'octocat'
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
end
