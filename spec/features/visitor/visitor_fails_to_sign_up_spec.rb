require 'spec_helper'

feature 'Visitor signs up' do
  scenario 'with an email and password' do
    visit sign_up_path
    click_on 'go'

    page.should_not have_content("Sign out")
  end
end
