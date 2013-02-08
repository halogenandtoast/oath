require 'spec_helper'
require 'monban/controller_helpers/sign_in'

describe Monban::SignIn, '#perform' do
  it 'sets the cookie' do
    user = double(id: 1)
    hash = {}
    cookies = double(signed: hash)

    Monban::SignIn.new(user, cookies).perform

    hash[:user_id].should eq(1)
  end
end
