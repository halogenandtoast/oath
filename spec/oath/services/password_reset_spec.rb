require 'spec_helper'
require 'oath/services/password_reset'
require 'ostruct'

describe Oath::Services::PasswordReset do
  before do
    Oath.config.hashing_method = ->(password) { password + "secret" }
  end

  it 'updates the password with the hashing strategy' do
    password_digest = Oath.hash_token('password')
    user = double()
    field = Oath.config.user_token_store_field
    allow(user).to receive(:[]=)
    password_reset = Oath::Services::PasswordReset.new(user, 'password')

    password_reset.perform
    expect(user).to have_received(:[]=).with(field, 'passwordsecret')
  end

  after do
    Oath.config.hashing_method = Oath.config.default_hashing_method
  end
end
