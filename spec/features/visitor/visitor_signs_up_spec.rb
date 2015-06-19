require 'spec_helper'

feature 'Visitor signs up' do
  scenario 'with an email and password' do
    visit sign_up_path
    fill_in 'user_email', with: 'email@example.com'
    fill_in 'user_password', with: 'password'
    click_on 'go'

    expect(page.current_path).to eq(posts_path)
  end

  scenario 'multiple users' do
    visit sign_up_path
    fill_in 'user_email', with: 'email@example.com'
    fill_in 'user_password', with: 'password'
    click_on 'go'
    click_on 'Sign out'
    visit sign_up_path
    fill_in 'user_email', with: 'email2@example.com'
    fill_in 'user_password', with: 'password2'
    click_on 'go'
    click_on 'Sign out'
    visit sign_in_path
    fill_in 'session_email', with: 'email@example.com'
    fill_in 'session_password', with: 'password'
    click_on 'go'

    expect(page.current_path).to eq(posts_path)
  end
end
