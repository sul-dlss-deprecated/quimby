# frozen_string_literal: true

class Dependency < ApplicationRecord
  belongs_to :repository
end
