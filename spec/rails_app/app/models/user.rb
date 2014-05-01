require 'active_hash'
class User < ActiveHash::Base
  include ActiveModel::Validations
  attr_accessor :email, :password_digest, :password
  validates :email, presence: true

  def self.find_by(params)
    where(params).first
  end
end
