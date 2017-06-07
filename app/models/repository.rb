# frozen_string_literal: true

class Repository < ApplicationRecord
  has_many :deploy_environments
  has_many :servers, through: :deploy_environments
end
