# frozen_string_literal: true

FactoryGirl.define do
  factory :first_dependency, class: Dependency do
    name 'existence'
    repository
  end

  factory :second_dependency, class: Dependency do
    name 'thesun'
    repository
  end
end
