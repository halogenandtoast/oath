require 'spec_helper'
require 'oath/services/sign_out'

describe Oath::Services::SignOut, '#perform' do
  it 'signs out the user' do
    warden = double()
    allow(warden).to receive(:logout)
    allow(warden).to receive(:user).and_return(double())

    Oath::Services::SignOut.new(warden).perform
    expect(warden).to have_received(:logout)
  end
end
