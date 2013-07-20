require 'spec_helper'
require 'monban/controller_helpers/sign_up'

describe Monban::SignUp, '#perform' do
  it 'creates a user with the right parameters' do
    create = double
    stub_const('User', create)
    user_params = { 'email' => 'email@example.com', 'password' => 'password' }

    create.should_receive(:create) do |args|
      args[:email].should eq(user_params[:email])
      Monban.compare_token(args[:password_digest], 'password').should be_true
    end

    Monban::SignUp.new(user_params).perform
  end
end
