require 'spec_helper'
require 'monban/services/sign_up'

describe Monban::SignUp, '#perform' do
  it 'creates a user with the right parameters' do
    create = double
    stub_const('User', create)
    user_params = { email: 'email@example.com', password: 'password' }

    create.should_receive(:create) do |args|
      args[:email].should eq(user_params[:email])
      Monban.compare_token(args[:password_digest], 'password').should be_true
    end

    Monban::SignUp.new(user_params).perform
  end

  it 'creates a user from the configured user creation method' do
    user_create_double = ->(user_params) { }
    user_create_double.should_receive(:call) do |args|
      Monban.compare_token(args[:password_digest], 'password').should be_true
    end

    user_params = { email: 'email@example.com', password: 'password' }
    swap_creation_method user_create_double do
      Monban::SignUp.new(user_params).perform
    end
  end

  def swap_creation_method(new_creation_method, &block)
    old_creation_method = Monban.config.creation_method
    Monban.config.creation_method = new_creation_method
    yield
  ensure
    Monban.config.creation_method = old_creation_method
  end

  it 'does not create a user with an empty password' do
    create = double
    stub_const('User', create)
    user_params = { email: 'email@example.com', password: '' }

    create.should_receive(:create) do |args|
      args[:password_digest].should be_nil
    end

    Monban::SignUp.new(user_params).perform
  end
end
