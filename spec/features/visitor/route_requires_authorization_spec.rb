require 'spec_helper'

feature 'Route requires authentication' do
  context 'when visiting while logged out' do
    it 'responds with HTTP 401' do
      visit authenticated_path
      expect(page.status_code).to eq 401
    end
  end

  context 'when visiting while logged in' do
    it 'responds with HTTP 200' do
      visit sign_up_path
      fill_in 'user_email', with: 'email@example.com'
      fill_in 'user_password', with: 'password'
      click_on 'go'

      visit authenticated_path
      expect(page.status_code).to eq 200
    end
  end
end
