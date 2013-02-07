require 'monban'
require 'warden'

module Monban
  class Railtie < Rails::Railtie
    config.app_middleware.use Warden::Manager do |config|
      Monban.warden_config = config
    end
  end
end
