require 'active_hash'
class User < ActiveHash::Base
  include ActiveModel::Validations
  attr_accessor :email, :password_digest, :password
  validates :email, presence: true
end
