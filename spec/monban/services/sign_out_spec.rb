require 'spec_helper'
require 'monban/services/sign_out'

describe Monban::Services::SignOut, '#perform' do
  it 'signs out the user' do
    warden = double()
    allow(warden).to receive(:logout)

    Monban::Services::SignOut.new(warden).perform
    expect(warden).to have_received(:logout)
  end
end
