require 'spec_helper'

feature 'User tries to access constrained routes' do
  scenario 'they can access a route constrained to users' do
    sign_in User.new

    visit constrained_to_users_path
    expect(page.status_code).to eq(200)
  end

  scenario 'they cannot access a route constrained to visitors' do
    sign_in User.new

    expect {
      visit constrained_to_visitors_path
    }.to raise_error ActionController::RoutingError
  end
end
