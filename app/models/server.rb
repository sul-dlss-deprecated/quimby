# frozen_string_literal:true

class Server < ApplicationRecord
  include Filterable

  has_many :deploy_environments
  has_many :repositories, through: :deploy_environments

  scope :pupgraded, ->(pupgraded) { where(pupgraded: pupgraded) }
end
