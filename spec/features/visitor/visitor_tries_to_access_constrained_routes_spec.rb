require 'spec_helper'

feature 'Visitor tries to access constrained routes' do
  scenario 'they can access a route constrained to visitors' do
    visit constrained_to_visitors_path
    expect(page.status_code).to eq(200)
  end

  scenario 'they cannot access a route constrained to users' do
    expect {
      visit constrained_to_users_path
    }.to raise_error ActionController::RoutingError
  end
end
