require 'spec_helper'

feature 'Visitor signs in' do
  scenario 'with remember token' do
    Monban::Services::SignUp.new(email: "email@example.com", password: "password").perform
    visit sign_in_path
    fill_in 'session_email', with: 'email@example.com'
    fill_in 'session_password', with: 'password'
    check 'remember_me'
    click_on 'go'
    puts cookies.inspect
  end

  def cookie_jar
    page.driver.browser.current_session.instance_variable_get(:@rack_mock_session).cookie_jar
  end

  def cookies
    cookie_jar.instance_variable_get(:@cookies)
  end
end
