# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Filterable do
  it 'filters by params' do
    create_list(:repository_index, 5)
    result = Repository.all
    expect(result.filter(language: 'ruby', deployable: 'true', monitorable: 'true', tested: 'true', documented: 'false').count).to eq 5
  end
end
