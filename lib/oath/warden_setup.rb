require 'warden'
require "oath/strategies/password_strategy"

module Oath
  # Sets up warden specifics for working with oath
  class WardenSetup
    def initialize(warden_config)
      @warden_config = warden_config
    end

    # Sets up warden specifics for working with oath:
    # * Session serialization
    # * Strategy
    # * Failure app
    def call
      setup_warden_manager
      setup_warden_strategies
      setup_warden_config
    end

    private
    attr_reader :warden_config

    def setup_warden_manager
      Warden::Manager.serialize_into_session(&serialize_into_session_method)
      Warden::Manager.serialize_from_session(&serialize_from_session_method)
    end

    def setup_warden_strategies
      Warden::Strategies.add(:password_strategy, Oath.config.authentication_strategy)
    end

    def setup_warden_config
      warden_config.tap do |config|
        config.failure_app = Oath.config.failure_app
      end
    end

    def serialize_into_session_method
      Oath.config.warden_serialize_into_session
    end

    def serialize_from_session_method
      Oath.config.warden_serialize_from_session
    end
  end
end
