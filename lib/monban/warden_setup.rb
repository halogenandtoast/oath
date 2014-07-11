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
      Warden::Manager.serialize_into_session do |user|
        user.id
      end

      Warden::Manager.serialize_from_session do |id|
        Monban.config.user_class.find_by(id: id)
      end
    end

    def setup_warden_strategies
      Warden::Strategies.add(:password_strategy, Monban.config.authentication_strategy)
    end

    def setup_warden_config
      warden_config.tap do |config|
        config.failure_app = Monban.config.failure_app
      end
    end
  end
end
