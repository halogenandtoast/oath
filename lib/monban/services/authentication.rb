module Monban
  class Authentication
    def initialize user, undigested_token
      @user = user
      @undigested_token = undigested_token
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
      @user && Monban.compare_token(@user.send(token_store_field), @undigested_token)
    end

    def token_store_field
      Monban.config.user_token_store_field
    end
  end
end
