module Monban
  # Authentication service. Checks to see if the credentials provided are valid
  class Authentication
    # Initialize service
    #
    # @param user [User] A user object
    # @param undigested_token [String] An undigested password
    def initialize user, undigested_token
      @user = user
      @undigested_token = undigested_token
    end

    # Perform the service
    #
    # @return [User] if authentication succeeds
    # @return [false] if authentication fails
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
