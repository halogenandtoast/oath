require 'warden'
require 'monban/console_helpers'

module Monban
  # Railtie for Monban. Injects the Warden middleware and initializes Monban.
  # @since 0.0.15
  class Railtie < Rails::Railtie
    config.app_middleware.use Warden::Manager do |config|
      Monban.initialize(config)
    end

    console do
      TOPLEVEL_BINDING.eval('self').extend Monban::ConsoleHelpers
    end
  end
end
