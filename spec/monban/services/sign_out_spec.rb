require 'spec_helper'
require 'monban/services/sign_out'

describe Monban::Services::SignOut, '#perform' do
  it 'signs out the user' do
    warden = double()
    warden.should_receive(:logout)

    Monban::Services::SignOut.new(warden).perform
  end
end
