require 'active_hash'
class User < ActiveHash::Base
  attr_accessor :email, :password_digest, :password
end
