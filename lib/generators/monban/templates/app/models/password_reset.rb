class PasswordReset < ActiveRecord::Base
  belongs_to :user
  before_create :generate_unique_token
  delegate :email, to: :user, allow_nil: true

  def to_param
    token
  end

  private

  def generate_unique_token
    self.token = generate_token
    while PasswordReset.exists?(token: self.token)
      self.token = generate_token
    end
  end

  def generate_token
    SecureRandom.hex(20).encode('UTF-8')
  end
end
