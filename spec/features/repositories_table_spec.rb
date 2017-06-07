# frozen_string_literal: true

require 'rails_helper'

describe 'Repositories index table', type: :feature do
  it 'link for repo name to github' do
    r = create(:repository_index)
    visit repositories_index_path
    expect(body).to have_link('Hello-World', href: 'github.com')
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
end
