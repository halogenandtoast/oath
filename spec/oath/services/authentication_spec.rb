require 'spec_helper'
require 'oath/services/authentication'

describe Oath::Services::Authentication, '#authentication' do
  it 'is authenticated for a valid password' do
    password_digest = BCrypt::Password.create('password')
    user = double(password_digest: password_digest)
    auth = Oath::Services::Authentication.new(user, 'password')

    expect(auth.perform).to eq(user)
  end

  it 'is not authenticated for the wrong password' do
    password_digest = BCrypt::Password.create('password')
    user = double(password_digest: password_digest)
    auth = Oath::Services::Authentication.new(user, 'drowssap')

    expect(auth.perform).to eq(false)
  end

  it 'is not authenticated without a user' do
    auth = Oath::Services::Authentication.new(nil, 'password')
    expect(auth.perform).to eq(false)
  end
end
