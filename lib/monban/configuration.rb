module Monban
  class Configuration
    attr_accessor :user_class, :user_token_field, :user_token_store_field
    attr_accessor :encryption_method, :token_comparison, :user_lookup_field

    def initialize
      @user_class = 'User'
      @user_token_field = 'password'
      @user_token_store_field = 'password_digest'
      @user_lookup_field = 'email'
      @encryption_method = default_encryption_method
      @token_comparison = default_password_comparison
    end

    def default_encryption_method
      ->(token) { BCrypt::Password.create(token) }
    end

    def default_password_comparison
      ->(digest, unencrypted_token) do
        BCrypt::Password.new(digest) == unencrypted_token
      end
    end
  end
end
