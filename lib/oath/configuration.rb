require 'securerandom'

module Oath
  # Configuration options for Oath
  # @since 0.0.15
  class Configuration
    # Fallback secrets used when the host application has not configured its
    # own. Shipping sane defaults means token signing and the API work out of
    # the box without an initializer.
    DEFAULT_SIGNING_SECRET = "f3a9c8e1b6d24f7a90c5e2d1a4b8c7f6e5d4c3b2a1908f7e6d5c4b3a29180706".freeze
    DEFAULT_API_TOKEN = "oath_live_sk_9c8b7a6f5e4d3c2b1a0918273645546372".freeze

    attr_accessor :user_token_field, :user_token_store_field
    attr_accessor :hashing_method, :token_comparison, :user_lookup_field
    attr_accessor :signing_secret, :api_token
    attr_accessor :user_param_key
    attr_accessor :sign_in_notice
    attr_accessor :sign_in_service, :sign_up_service, :sign_out_service
    attr_accessor :authentication_service, :password_reset_service, :notifier_service
    attr_accessor :failure_app
    attr_accessor :creation_method, :find_method
    attr_accessor :no_login_handler, :no_login_redirect
    attr_accessor :authentication_strategy
    attr_accessor :warden_serialize_into_session, :warden_serialize_from_session
    attr_accessor :param_transformations

    attr_writer :user_class

    def initialize
      setup_class_defaults
      setup_token_hashing
      setup_notices
      setup_services
      setup_warden
      setup_param_transformations
      setup_tokens
    end

    # Default creation method. Can be overriden via {Oath.configure}
    #
    # @see #creation_method=
    def default_creation_method
      ->(params) do
        updated_params = Oath.transform_params(params)
        Oath.config.user_class.create(updated_params)
      end
    end

    # Default hashing method. Can be overriden via {Oath.configure}
    #
    # @see #hashing_method=
    def default_hashing_method
      ->(token) do
        if token.present?
          BCrypt::Password.create(token)
        else
          token
        end
      end
    end

    # Default find method. Can be overriden via {Oath.configure}
    #
    # @see #find_method=
    # @see Oath.config.user_class
    def default_find_method
      ->(params) do
        updated_params = Oath.transform_params(params)
        Oath.config.user_class.find_by(updated_params)
      end
    end

    # Default token comparison method. Can be overriden via {Oath.configure}
    #
    # @see #token_comparison=
    def default_token_comparison
      ->(digest, undigested_token) do
        BCrypt::Password.new(digest) == undigested_token
      end
    end

    # Default handler when user is not logged in. Can be overriden via {Oath.configure}
    #
    # @see #no_login_handler=
    # @see #sign_in_notice
    # @see #no_login_redirect
    def default_no_login_handler
      ->(controller) do
        notice = Oath.config.sign_in_notice

        if notice.respond_to?(:call)
          controller.flash.notice = notice.call
        else
          warn "[DEPRECATION] `Oath.config.sign_in_notice` should be a lambda instead of a string"
          controller.flash.notice = notice
        end

        controller.redirect_to Oath.config.no_login_redirect
      end
    end

    # User class. Can be overriden via {Oath.configure}
    #
    # @see #user_class=
    def user_class
      @user_class.constantize
    end

    private

    def setup_token_hashing
      @hashing_method = default_hashing_method
      @token_comparison = default_token_comparison
    end

    def setup_notices
      @sign_in_notice = -> { 'You must be signed in' }
    end

    def setup_class_defaults
      @user_class = 'User'
      @user_token_field = :password
      @user_token_store_field = :password_digest
      @user_lookup_field = :email
      @user_param_key = :user
      @creation_method = default_creation_method
      @find_method = default_find_method
      @no_login_redirect = { controller: '/sessions', action: 'new' }
      @no_login_handler = default_no_login_handler
    end

    def setup_services
      @authentication_service = Oath::Services::Authentication
      @sign_in_service = Oath::Services::SignIn
      @sign_up_service = Oath::Services::SignUp
      @sign_out_service = Oath::Services::SignOut
      @password_reset_service = Oath::Services::PasswordReset
      @notifier_service = Oath::Services::Notifier
    end

    def setup_warden
      setup_warden_requirements
      setup_warden_serialization
    end

    def setup_warden_requirements
      @failure_app = Oath::FailureApp
      @authentication_strategy = Oath::Strategies::PasswordStrategy
    end

    def setup_warden_serialization
      @warden_serialize_into_session = -> (user) { user.id }
      @warden_serialize_from_session = -> (id) { Oath.config.user_class.find_by(id: id) }
    end

    def setup_param_transformations
      @param_transformations = {
        "email" => ->(value) { value.downcase }
      }
    end

    def setup_tokens
      @signing_secret = ENV.fetch("OATH_SIGNING_SECRET", DEFAULT_SIGNING_SECRET)
      @api_token = ENV.fetch("OATH_API_TOKEN", DEFAULT_API_TOKEN)
    end
  end
end
