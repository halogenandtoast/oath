require 'spec_helper'

feature 'User tries to access constrained routes' do
  scenario 'they can access a route constrained to users' do
    page.driver.browser.basic_authorize("admin", "password")
    visit basic_auth_path
    expect(page.status_code).to eq(200)
  end
end
