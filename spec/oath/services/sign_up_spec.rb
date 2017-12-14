require 'spec_helper'
require 'oath/services/sign_up'

describe Oath::Services::SignUp, '#perform' do
  it 'creates a user with the right parameters' do
    allow(User).to receive(:create)
    user_params = { email: 'email@example.com', password: 'password' }

    Oath::Services::SignUp.new(user_params).perform
    expect(User).to have_received(:create) do |args|
      expect(args[:email]).to eq(user_params[:email])
      expect(Oath.compare_token(args[:password_digest], 'password')).to be_truthy
    end
  end

  it 'creates a user from the configured user creation method' do
    user_create_double = double(Proc, call: true)

    user_params = { email: 'email@example.com', password: 'password' }

    with_oath_config(creation_method: user_create_double) do
      Oath::Services::SignUp.new(user_params).perform
    end

    expect(user_create_double).to have_received(:call) do |args|
      expect(Oath.compare_token(args[:password_digest], 'password')).to be_truthy
    end
  end

  it 'does not create a user with an empty password' do
    allow(User).to receive(:create)
    user_params = { email: 'email@example.com', password: '' }

    Oath::Services::SignUp.new(user_params).perform
    expect(User).to have_received(:create) do |args|
      expect(args[:password_digest]).to be_nil
    end
  end

  it 'does not create a user with a nil password' do
    allow(User).to receive(:create)
    user_params = { email: nil, password: nil }

    Oath::Services::SignUp.new(user_params).perform
    expect(User).to have_received(:create) do |args|
      expect(args[:password_digest]).to be_nil
    end
  end
end
