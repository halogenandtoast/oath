module Monban
  class PasswordReset
    def initialize user, password
      @user = user
      @password = password
    end

    def perform
      field = Monban.config.user_token_store_field
      digested_password = Monban.hash_token(@password)
      @user[field] = digested_password
    end
  end
end
