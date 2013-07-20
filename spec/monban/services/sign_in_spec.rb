require 'spec_helper'
require 'monban/controller_helpers/sign_in'

describe Monban::SignIn, '#perform' do
  it 'signs the user in' do
    user = double()
    warden = double()
    warden.should_receive(:set_user).with(user)

    Monban::SignIn.new(user, warden).perform
  end
end
