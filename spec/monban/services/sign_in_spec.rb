require 'spec_helper'
require 'monban/services/sign_in'

describe Monban::Services::SignIn, '#perform' do
  it 'signs the user in' do
    user = double()
    warden = double()
    warden.should_receive(:set_user).with(user)

    Monban::Services::SignIn.new(user, warden).perform
  end
end
