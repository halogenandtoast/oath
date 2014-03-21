require 'spec_helper'

feature 'Route requires authorization' do
  scenario 'denies access when visiting while logged out' do
    visit authenticated_path
    expect(page.status_code).to eq 401
  end

  scenario 'allows access when visiting while logged in' do
    visit sign_up_path
    fill_in 'user_email', with: 'email@example.com'
    fill_in 'user_password', with: 'password'
    click_on 'go'

    visit authenticated_path
    expect(page.status_code).to eq 200
  end
end
