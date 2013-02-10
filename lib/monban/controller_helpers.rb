require 'bcrypt'
require 'monban/controller_helpers/sign_in'
require 'monban/controller_helpers/sign_out'
require 'monban/controller_helpers/sign_up'
require 'monban/controller_helpers/authentication'
require 'active_support/concern'

module Monban
  module ControllerHelpers
    extend ActiveSupport::Concern
    included do
      helper_method :current_user, :signed_in?
    end

    def sign_in user
      SignIn.new(user, warden).perform
    end

    def sign_out
      SignOut.new(warden).perform
    end

    def sign_up user_params
      SignUp.new(user_params).perform
    end

    def authenticate_session session_params, field_map = nil
      user = Monban.lookup(session_params, field_map)
      password = session_params.delete(Monban.config.user_token_field)
      authenticate(user, password)
    end

    def authenticate user, password
      Authentication.new(user, password).perform
    end

    def warden
      env['warden']
    end

    def current_user
      warden.user
    end

    def signed_in?
      current_user
    end

    def require_login
      unless signed_in?
        flash.notice = Monban.config.sign_in_notice
        redirect_to '/sign_in'
      end
    end
  end
end
