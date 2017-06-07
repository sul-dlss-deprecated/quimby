# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository, type: :model do
  it { is_expected.to have_many(:deploy_environments) }
  it { is_expected.to have_many(:servers).through(:deploy_environments) }
end
