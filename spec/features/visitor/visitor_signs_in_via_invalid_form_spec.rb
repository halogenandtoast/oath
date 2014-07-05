require 'spec_helper'

feature 'Visitor signs in with invalid form' do
  scenario 'is not signed in' do
    Monban::Services::SignUp.new(email: 'email@example.com', password: 'password').perform
    visit invalid_sign_in_path
    fill_in "session_password", with: 'password'
    click_button 'go'
    expect(page).to have_content("Sign in")
  end
end
