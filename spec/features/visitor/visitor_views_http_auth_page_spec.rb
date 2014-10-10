require 'spec_helper'

feature 'HTTP auth' do
  include Rack::Test::Methods

  scenario 'when valid username and password' do
    page.driver.browser.authorize 'username', 'password'
    visit http_basic_auth_path
    expect(page).to have_content("Success")
  end

  scenario 'when invalid username and password' do
    page.driver.browser.authorize 'nope', 'nope'
    visit http_basic_auth_path
    expect(page).to have_content("Need authorization")
  end

end
