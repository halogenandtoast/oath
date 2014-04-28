require 'spec_helper'

feature 'Visitor signs up' do
  scenario 'with an email and password' do
    visit sign_up_path
    click_on 'go'

    expect(page).not_to have_content("Sign out")
  end
end
