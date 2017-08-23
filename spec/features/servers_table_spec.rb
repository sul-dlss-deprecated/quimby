# frozen_string_literal: true

require 'rails_helper'

describe 'Servers index table', type: :feature do
  it 'displays server information' do
    create(:server_index)
    visit servers_path
    expect(body).to have_text('server-dev')
    expect(body).to have_text('123.45.67.890')
    expect(body).to have_text('pupgraded')
  end

  it 'displays a link when server belongs to a deploy environment' do
    create(:repo_with_servers)
    visit servers_path
    expect(body).to have_link('server-prod-b', href: '/repositories/Hello-World')
  end

  it 'gets correct results from true filter' do
    create(:server_index)
    visit servers_path
    find('#pupgraded').select('true')
    click_button 'Filter'
    expect(body).to have_text('server-dev')
  end

  it 'gets correct results from false filter' do
    create(:server_index)
    visit servers_path
    find('#pupgraded').select('false')
    click_button 'Filter'
    expect(body).not_to have_text('server-dev')
  end
end
