require 'warden'
require "monban/strategies/password_strategy"
require "monban/strategies/remember_me_strategy"

module Monban
  # Sets up warden specifics for working with monban

  EXTENSIONS = {
    strategies: {
      remember_me: Strategies::RememberMeStrategy
    }
  }

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
      setup_warden_extensions
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

    def setup_warden_extensions
      Monban.config.extensions.each do |extension|
        if strategy = EXTENSIONS[:strategies][extension.to_sym]
          Warden::Strategies.add(extension.to_sym, strategy)
        end
      end
    end

    def setup_warden_config
      warden_config.tap do |config|
        config.failure_app = Monban.config.failure_app
        strategies = EXTENSIONS[:strategies].keys & Monban.config.extensions
        config.scope_defaults(config.default_scope, strategies: strategies)
      end
    end
  end
end
