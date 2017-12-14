require 'warden'

module Oath
  # Railtie for Oath. Injects the Warden middleware and initializes Oath.
  # @since 0.0.15
  class Railtie < Rails::Railtie
    config.app_middleware.use Warden::Manager do |config|
      Oath.initialize(config)
    end
  end
end
