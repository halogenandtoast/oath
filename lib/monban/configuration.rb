module Monban
  class Configuration
    attr_accessor :user_class, :user_password_field, :user_lookup_field
    attr_accessor :encryption_method, :password_comparison
    def initialize
      @user_class = 'User'
      @user_password_field = 'password'
      @user_lookup_field = 'email'
      @encryption_method = default_encryption_method
      @password_comparison = default_password_comparison
    end

    def default_encryption_method
      ->(password) { BCrypt::Password.create(password) }
    end

    def default_password_comparison
      ->(digest, unencrypted_password) do
        BCrypt::Password.new(digest) == unencrypted_password
      end
    end
  end
end
