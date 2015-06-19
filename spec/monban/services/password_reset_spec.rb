require 'spec_helper'
require 'monban/services/password_reset'
require 'ostruct'

describe Monban::Services::PasswordReset do
  before do
    Monban.config.hashing_method = ->(password) { password + "secret" }
  end

  it 'updates the password with the hashing strategy' do
    password_digest = Monban.hash_token('password')
    user = double()
    field = Monban.config.user_token_store_field
    allow(user).to receive(:[]=)
    password_reset = Monban::Services::PasswordReset.new(user, 'password')

    password_reset.perform
    expect(user).to have_received(:[]=).with(field, 'passwordsecret')
  end

  after do
    Monban.config.hashing_method = Monban.config.default_hashing_method
  end
end
