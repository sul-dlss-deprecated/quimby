# frozen_string_literal: true

class DeployEnvironment < ApplicationRecord
  belongs_to :repository
  belongs_to :server
end
