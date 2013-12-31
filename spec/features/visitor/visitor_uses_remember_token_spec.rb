require 'spec_helper'

feature 'Visitor signs in' do
  scenario 'with remember token' do
    pending
    Monban::SignUp.new(email: "email@example.com", password: "password").perform
    visit sign_in_path
    fill_in 'session_email', with: 'email@example.com'
    fill_in 'session_password', with: 'password'
    check 'Remember me'
    click_on 'go'
  end
end
