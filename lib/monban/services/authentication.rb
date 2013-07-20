module Monban
  class Authentication
    def initialize user, unencrypted_token
      @user = user
      @unencrypted_token = unencrypted_token
    end

    def perform
      if authenticated?
        @user
      else
        false
      end
    end

    private

    def authenticated?
      @user && Monban.compare_token(@user.send(token_store_field), @unencrypted_token)
    end

    def token_store_field
      Monban.config.user_token_store_field
    end
  end
end
