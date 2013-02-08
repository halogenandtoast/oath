require 'spec_helper'
require 'monban/controller_helpers/authentication'

describe Monban::Authentication, '#authentication' do
  it 'is authenticated for a valid password' do
    password_digest = BCrypt::Password.create('password')
    user = stub(password_digest: password_digest)
    auth = Monban::Authentication.new(user, 'password')

    auth.should be_authenticated
  end

  it 'is not authenticated for the wrong password' do
    password_digest = BCrypt::Password.create('password')
    user = stub(password_digest: password_digest)
    auth = Monban::Authentication.new(user, 'drowssap')

    auth.should_not be_authenticated
  end
end
