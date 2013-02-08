require 'spec_helper'

feature 'Visitor signs up' do
  scenario 'with an email and password' do
    visit sign_up_path
    fill_in 'user_email', with: 'email@example.com'
    fill_in 'user_password', with: 'password'
    click_on 'go'

    page.current_path.should eq(posts_path)
  end
end
