require 'bcrypt'
require 'active_support/concern'

module Monban
  # Mixin to be included in Rails controllers.
  # @since 0.0.15
  module ControllerHelpers
    extend ActiveSupport::Concern
    included do
      helper_method :current_user, :signed_in?
    end

    # Sign in a user
    #
    # @note Uses the {Monban::Services::SignIn} service to create a session
    #
    # @param user [User] the user object to sign in
    # @yield Yields to the block if the user is successfully signed in
    # @return [Object] returns the value from calling perform on the {Monban::Services::SignIn} service
    def sign_in user
      Monban.config.sign_in_service.new(user, warden).perform.tap do |status|
        if status && block_given?
          yield
        end
      end
    end

    # Sign out the current session
    #
    # @note Uses the {Monban::Services::SignOut} service to destroy the session
    #
    # @return [Object] returns the value from calling perform on the {Monban::Services::SignOut} service
    def sign_out
      Monban.config.sign_out_service.new(warden).perform
    end

    # Sign up a user
    #
    # @note Uses the {Monban::Services::SignUp} service to create a user
    #
    # @param user_params [Hash] params containing lookup and token fields
    # @yield Yields to the block if the user is signed up successfully
    # @return [Object] returns the value from calling perform on the {Monban::Services::SignUp} service
    def sign_up user_params
      Monban.config.sign_up_service.new(user_params).perform.tap do |status|
        if status && block_given?
          yield
        end
      end
    end

    # Authenticates a session.
    #
    # @note Uses the {Monban::Services::Authentication} service to verify the user's details
    #
    # @param session_params [Hash] params containing lookup and token fields
    # @param field_map [Hash] Field map used for allowing users to sign in with multiple fields e.g. email and username
    # @return [User] if authentication succeeded
    # @return [nil] if authentication failed
    # @example Basic usage
    #   class SessionsController < ApplicationController
    #     def create
    #       user = authenticate_session(session_params)
    #
    #        if sign_in(user)
    #          redirect_to(root_path)
    #        else
    #          render :new
    #        end
    #      end
    #
    #      private
    #
    #      def session_params
    #        params.require(:session).permit(:email, :password)
    #      end
    #
    #    end
    # @example Using the field map to authenticate using multiple lookup fields
    #   class SessionsController < ApplicationController
    #     def create
    #       user = authenticate_session(session_params, email_or_username: [:email, :username])
    #
    #        if sign_in(user)
    #          redirect_to(root_path)
    #        else
    #          render :new
    #        end
    #      end
    #
    #      private
    #
    #      def session_params
    #        params.require(:session).permit(:email_or_username, :password)
    #      end
    #
    #    end

    def authenticate_session session_params, field_map = nil
      token_field = Monban.config.user_token_field
      session_params_hash = session_params.to_h.with_indifferent_access
      password = session_params_hash.fetch(token_field)
      user = Monban.lookup(session_params_hash.except(token_field), field_map)
      authenticate(user, password)
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

    # @api private
    def warden
      request.env['warden']
    end

    # helper_method that returns the current user
    #
    # @return [User] if user is signed in
    # @return [nil] if user is not signed in
    def current_user
      @current_user ||= warden.user
    end

    # helper_method that checks if there is a user signed in
    #
    # @return [User] if user is signed in
    # @return [nil] if user is not signed in
    def signed_in?
      warden.user
    end

    # before_action that determines what to do when the user is not signed in
    #
    # @note Uses the no login handler
    def require_login
      unless signed_in?
        Monban.config.no_login_handler.call(self)
      end
    end
  end
end
