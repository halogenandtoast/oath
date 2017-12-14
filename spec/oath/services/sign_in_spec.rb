require 'spec_helper'
require 'oath/services/sign_in'

describe Oath::Services::SignIn, '#perform' do
  it 'signs the user in' do
    user = double()
    warden = double()
    allow(warden).to receive(:set_user)

    Oath::Services::SignIn.new(user, warden).perform
    expect(warden).to have_received(:set_user).with(user)
  end
end
