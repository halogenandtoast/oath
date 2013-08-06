module Monban
  class PasswordReset
    def initialize user, password
      @user = user
      @password = password
    end

    def perform
      field = Monban.config.user_token_store_field
      encrypted_password = Monban.encrypt_token(@password)
      @user.write_attribute(field, encrypted_password)
    end
  end
end
