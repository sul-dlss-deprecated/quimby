# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Server, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:deploy_environments) }
    it { is_expected.to have_many(:repositories).through(:deploy_environments) }
  end
end
