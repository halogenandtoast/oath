require 'spec_helper'

feature 'User signs in' do
  scenario 'with mismatched email case' do
    user = User.create!(email: "example@example.com", password_digest: "password")

    visit sign_in_path
    fill_in "session[email]", with: "Example@example.com"
    fill_in "session[password]", with: "password"
    click_button "go"

    expect(current_path).to eq posts_path
  end

  scenario 'with username or password' do
    user = User.create!(
      email: "example@example.com",
      password_digest: "password",
      username: "example",
    )

    visit multiple_attributes_sign_in_path
    fill_in "session_email_or_username", with: user.username
    fill_in "session_password", with: 'password'
    click_button 'go'

    expect(current_path).to eq posts_path
  end
end
