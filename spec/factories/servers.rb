# frozen_string_literal: true

FactoryGirl.define do
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
end
