# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Auth', type: :feature do
  let(:user) { create(:user) }

  it 'the user can log in and out' do
    visit root_path

    fill_in 'user_username', with: user.username
    fill_in 'user_password', with: user.password

    click_button 'Sign in'
    expect(page).to have_content('Repositories')

    click_link 'Logout'
    expect(page).to have_content('Sign in')
  end
end
