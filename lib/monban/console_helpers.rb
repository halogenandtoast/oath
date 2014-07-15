module Monban
  # Mixin to be included in Rails controllers.
  # @since 0.0.15
  module ConsoleHelpers
    # Sign up a user
    #
    # @note Uses the {Monban::Services::SignUp} service to create a user
    #
    # @param user_params [Hash] params containing lookup and token fields
    # @yield Yields to the block if the user is signed up successfully
    # @return [Object] returns the value from calling perform on the {Monban::Services::SignUp} service
    def sign_up user_params
      Monban.config.sign_up_service.new(user_params).perform
    end

    # Authenticates a user given a password
    #
    # @note Uses the {Monban::Services::Authentication} service to verify the user's credentials
    #
    # @param user [User] the user
    # @param password [String] the password
    # @return [User] if authentication succeeded
    # @return [nil] if authentication failed
    def authenticate user, password
      Monban.config.authentication_service.new(user, password).perform
    end

    # Resets a user's password
    #
    # @note Uses the {Monban::Services::PasswordReset} service to change a user's password
    #
    # @param user [User] the user
    # @param password [String] the password
    def reset_password user, password
      Monban.config.password_reset_service.new(user, password).perform
    end
  end
end
