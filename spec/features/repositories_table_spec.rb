# frozen_string_literal: true

require 'rails_helper'

describe 'Repositories index table', type: :feature do
  it 'link for repo name to github' do
    r = create(:repository_index)
    visit repositories_path
    expect(body).to have_link('Hello-World', href: '/repositories/Hello-World')
    expect(body).to have_css("img[src*='github']")
    expect(body).to have_text(r.language.downcase.to_s)
    expect(body).to have_text('rails')
    expect(body).to have_text('gem')
    expect(body).to have_text('capistrano')
    expect(body).to have_text('honeybadger')
    expect(body).to have_link(href: "https://travis-ci.org/#{r.organization}/#{r.name}")
    expect(body).to have_link(href: "https://coveralls.io/github/#{r.organization}/#{r.name}?branch=master")
    expect(body).to have_text('okcomputer')
    expect(body).to have_text('is_it_working')
  end

  it 'form sets valid params' do
    create(:repository_index)
    visit repositories_path
    find('#deployable').select('true')
    find('#tracked').select('true')
    find('#language').select('ruby')
    find('#monitorable').select('true')
    find('#tested').select('true')
    click_button 'Filter'
    expect(body).to have_link('Hello-World', href: '/repositories/Hello-World')
  end

  it 'filters from deployable' do
    create(:repository_index)
    visit repositories_path
    find('#deployable').select('false')
    click_button 'Filter'
    expect(body).not_to have_link('Hello-World', href: '/repositories/Hello-World')
  end

  it 'filters from documented' do
    create(:repository_index)
    visit repositories_path
    find('#tracked').select('false')
    click_button 'Filter'
    expect(body).not_to have_link('Hello-World', href: '/repositories/Hello-World')
  end

  it 'filters from monitorable' do
    create(:repository_index)
    visit repositories_path
    find('#monitorable').select('false')
    click_button 'Filter'
    expect(body).not_to have_link('Hello-World', href: '/repositories/Hello-World')
  end

  it 'filters from tested' do
    create(:repository_index)
    visit repositories_path
    find('#tested').select('false')
    click_button 'Filter'
    expect(body).not_to have_link('Hello-World', href: '/repositories/Hello-World')
  end
end
