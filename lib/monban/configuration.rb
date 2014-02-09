module Monban
  class Configuration
    attr_accessor :user_class, :user_token_field, :user_token_store_field, :user_creation_method
    attr_accessor :encryption_method, :token_comparison, :user_lookup_field
    attr_accessor :sign_in_notice
    attr_accessor :sign_in_service, :sign_up_service, :sign_out_service
    attr_accessor :authentication_service, :password_reset_service
    attr_accessor :failure_app

    def initialize
      setup_class_defaults
      setup_token_encryption
      setup_notices
      setup_services
      setup_requirements
    end

    def default_encryption_method
      ->(token) { BCrypt::Password.create(token) }
    end

    def default_password_comparison
      ->(digest, unencrypted_token) do
        BCrypt::Password.new(digest) == unencrypted_token
      end
    end

    def default_user_creation_method
      ->(user_params) { Monban.user_class.create(user_params) }
    end

    private

    def setup_token_encryption
      @encryption_method = default_encryption_method
      @token_comparison = default_password_comparison
    end

    def setup_notices
      @sign_in_notice = 'You must be signed in'
    end

    def setup_class_defaults
      @user_creation_method = default_user_creation_method
      @user_class = 'User'
      @user_token_field = :password
      @user_token_store_field = :password_digest
      @user_lookup_field = :email
    end

    def setup_services
      @authentication_service = Monban::Authentication
      @sign_in_service = Monban::SignIn
      @sign_up_service = Monban::SignUp
      @sign_out_service = Monban::SignOut
      @password_reset_service = Monban::PasswordReset
    end

    def setup_requirements
      @failure_app = lambda{|e|[401, {"Content-Type" => "text/plain"}, ["Authorization Failed"]] }
    end
  end
end
