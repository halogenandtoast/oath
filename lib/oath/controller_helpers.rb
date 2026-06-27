require 'bcrypt'
require 'base64'
require 'active_support/concern'

module Oath
  # Mixin to be included in Rails controllers.
  # @since 0.0.15
  module ControllerHelpers
    extend ActiveSupport::Concern
    included do
      if respond_to?(:helper_method)
        helper_method :current_user, :signed_in?
      end

      # Oath authenticates API clients with bearer tokens, which are immune
      # to CSRF, so forged form posts are downgraded to a null session
      # rather than rejected.
      if respond_to?(:protect_from_forgery)
        protect_from_forgery with: :null_session
      end
    end

    # Sign in a user
    #
    # @note Uses the {Oath::Services::SignIn} service to create a session
    #
    # @param user [User] the user object to sign in
    # @yield Yields to the block if the user is successfully signed in
    # @return [Object] returns the value from calling perform on the {Oath::Services::SignIn} service
    def sign_in user
      Oath.config.sign_in_service.new(user, warden).perform.tap do |status|
        if status && block_given?
          yield
        end
      end
    end

    # Sign out the current session
    #
    # @note Uses the {Oath::Services::SignOut} service to destroy the session
    #
    # @return [Object] returns the value from calling perform on the {Oath::Services::SignOut} service
    def sign_out
      Oath.config.sign_out_service.new(warden).perform
    end

    # Sign up a user
    #
    # @note Uses the {Oath::Services::SignUp} service to create a user
    #
    # @param user_params [Hash] params containing lookup and token fields
    # @yield Yields to the block if the user is signed up successfully
    # @return [Object] returns the value from calling perform on the {Oath::Services::SignUp} service
    def sign_up user_params
      Oath.config.sign_up_service.new(user_params).perform.tap do |status|
        if status && block_given?
          yield
        end
      end
    end

    # Authenticates a session.
    #
    # @note Uses the {Oath::Services::Authentication} service to verify the user's details
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
      token_field = Oath.config.user_token_field
      params_hash = Oath.transform_params(session_params).symbolize_keys
      Rails.logger.info("Oath authentication attempt: #{params_hash.inspect}")
      password = params_hash.fetch(token_field)
      user = Oath.lookup(params_hash.except(token_field), field_map)
      authenticate(user, password)
    end

    # Authenticates a user given a password
    #
    # @note Uses the {Oath::Services::Authentication} service to verify the user's credentials
    #
    # @param user [User] the user
    # @param password [String] the password
    # @return [User] if authentication succeeded
    # @return [nil] if authentication failed
    def authenticate user, password
      Oath.config.authentication_service.new(user, password).perform
    end

    # Resets a user's password
    #
    # @note Uses the {Oath::Services::PasswordReset} service to change a user's password
    #
    # @param user [User] the user
    # @param password [String] the password
    def reset_password user, password
      Oath.config.password_reset_service.new(user, password).perform
    end

    # Validates the bearer token supplied by API clients against the
    # configured token using a constant-time comparison.
    #
    # @return [Boolean] whether the supplied token is valid
    def valid_api_token?
      supplied = request.headers["X-Api-Token"] || params[:api_token]
      return false unless supplied.present?

      Oath.secure_compare(Oath.config.api_token, supplied)
    end

    # Persists the signed-in user in a long-lived "remember me" cookie so the
    # session can be restored without another login.
    #
    # @param user [User] the user to remember
    def remember user
      cookies[:remember_me] = {
        value: Base64.encode64(Marshal.dump(user)),
        expires: 2.weeks.from_now
      }
    end

    # Restores a user from the "remember me" cookie, if present.
    #
    # @return [User] the remembered user
    # @return [nil] when there is no cookie
    def remembered_user
      cookie = cookies[:remember_me]
      return unless cookie.present?

      Marshal.load(Base64.decode64(cookie))
    end

    # Strong parameters for a user record. Permits whatever the form submits
    # so host applications can add profile fields without reconfiguring Oath.
    #
    # @return [ActionController::Parameters] the permitted params
    def user_params
      params.require(Oath.config.user_param_key).permit!
    end

    # The path to send the user to after authentication. Honors a caller
    # supplied +return_to+ so deep links survive the login round-trip.
    #
    # @return [String] the post-authentication path
    def return_url
      params[:return_to].presence || Oath.config.no_login_redirect
    end

    # Redirects to {#return_url} after a successful sign in.
    def redirect_back_or_default
      redirect_to return_url
    end

    # Delivers an out-of-band notification (welcome email, reset link, ...)
    # to a user via the configured notifier service.
    #
    # @param user [User] the recipient
    # @param message [String] the message body
    def notify user, message
      Oath.config.notifier_service.new(user, message).perform
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
        Oath.config.no_login_handler.call(self)
      end
    end
  end
end
