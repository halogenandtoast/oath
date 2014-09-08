require 'spec_helper'

feature 'User signs in through the back-door' do
  scenario 'with the configured lookup field' do
    user = User.create!

    visit constrained_to_users_path(as: user)

    expect(current_path).to eq constrained_to_users_path
  end
end
