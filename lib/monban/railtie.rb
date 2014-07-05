require 'warden'

module Monban
  # Railtie for Monban. Injects the Warden middleware and initializes Monban.
  # @since 0.0.15
  class Railtie < Rails::Railtie
    config.app_middleware.use Warden::Manager do |config|
      Monban.initialize(config)
    end
  end
end
