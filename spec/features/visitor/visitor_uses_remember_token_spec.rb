require 'spec_helper'

feature 'Visitor signs in' do
  scenario 'sets remember token' do
    with_monban_config(extensions: [:remember_me]) do

      Monban::Services::SignUp.new(email: "email@example.com", password: "password").perform

      visit sign_in_path
      fill_in 'session_email', with: 'email@example.com'
      fill_in 'session_password', with: 'password'
      check 'remember_me'
      click_on 'go'

      expect(remember_me_cookie).to be_present
      expect(remember_me_cookie.expires).to be_present
    end
  end

  scenario 'visits page with remember token set' do
    with_monban_config(extensions: [:remember_me]) do
      user = Monban::Services::SignUp.new(email: "email@example.com", password: "password").perform
      cookie_jar["remember_me"] = user.id

      visit posts_path

      expect(page.current_path).to eq(posts_path)
    end
  end

  def remember_me_cookie
    cookies.find do |cookie|
      cookie.name == 'remember_me'
    end
  end

  def cookie_jar
    page.driver.browser.current_session.instance_variable_get(:@rack_mock_session).cookie_jar
  end

  def cookies
    cookie_jar.instance_variable_get(:@cookies)
  end
end
