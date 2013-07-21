require 'bcrypt'
require 'active_support/concern'

module Monban
  module ControllerHelpers
    extend ActiveSupport::Concern
    included do
      helper_method :current_user, :signed_in?
    end

    def sign_in user
      Monban.config.sign_in_service.new(user, warden).perform.tap do |status|
        if status && block_given?
          yield
        end
      end
    end

    def sign_out
      Monban.config.sign_out_service.new(warden).perform
    end

    def sign_up user_params
      Monban.config.sign_up_service.new(user_params).perform.tap do |status|
        if status && block_given?
          yield
        end
      end
    end

    def authenticate_session session_params, field_map = nil
      password = session_params.fetch(Monban.config.user_token_field)
      user = Monban.lookup(session_params.except(Monban.config.user_token_field), field_map)
      authenticate(user, password)
    end

    def authenticate user, password
      Monban.config.authentication_service.new(user, password).perform
    end

    def warden
      env['warden']
    end

    def current_user
      warden.user
    end

    def signed_in?
      warden.user
    end

    def require_login
      unless signed_in?
        flash.notice = Monban.config.sign_in_notice
        redirect_to controller: 'sessions', action: 'new'
      end
    end
  end
end
