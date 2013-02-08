require 'spec_helper'
require 'monban/controller_helpers/sign_out'

describe Monban::SignOut, '#perform' do
  it 'removes the cookie' do
    cookies = { user_id: true }

    Monban::SignOut.new(cookies).perform

    cookies.should_not have_key(:user_id)
  end
end
