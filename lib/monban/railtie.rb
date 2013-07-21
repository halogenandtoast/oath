require 'warden'

module Monban
  class Railtie < Rails::Railtie
    config.app_middleware.use Warden::Manager do |config|
      Monban.initialize(config)
    end
  end
end
