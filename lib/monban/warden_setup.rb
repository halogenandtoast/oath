require 'warden'
require "monban/strategies/password_strategy"

module Monban
  # Sets up warden specifics for working with monban
  class WardenSetup
    def initialize(warden_config)
      @warden_config = warden_config
    end

    # Sets up warden specifics for working with monban:
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
      Warden::Strategies.add(:password_strategy, Monban.config.authentication_strategy)
    end

    def setup_warden_config
      warden_config.tap do |config|
        config.failure_app = Monban.config.failure_app
      end
    end

    def serialize_into_session_method
      Monban.config.warden_serialize_into_session
    end

    def serialize_from_session_method
      Monban.config.warden_serialize_from_session
    end
  end
end
