require 'spec_helper'
require 'monban/services/password_reset'
require 'ostruct'

describe Monban::PasswordReset do
  before do
    Monban.config.encryption_method = ->(password) { password + "secret" }
  end

  it 'updates the password with the encryption strategy' do
    password_digest = Monban.encrypt_token('password')
    user = double()
    field = Monban.config.user_token_store_field
    user.should_receive(:write_attribute).with(field, 'passwordsecret')
    password_reset = Monban::PasswordReset.new(user, 'password')

    password_reset.perform
  end

  after do
    Monban.config.encryption_method = Monban.config.default_encryption_method
  end
end
