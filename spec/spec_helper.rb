ENV["RAILS_ENV"] = "test"
$LOAD_PATH.unshift File.dirname(__FILE__)

require 'rails_app/config/environment'
require 'rspec/rails'
require 'warden'
require 'monban'
require 'capybara'

RSpec.configure do |config|
  config.include Warden::Test::Helpers
   config.include Monban::Test::Helpers, type: :feature
  config.order = "random"
end

def with_monban_config(hash = {}, &block)
  old_config = Monban.config
  Monban.config = Monban::Configuration.new(hash)
  Warden::Strategies.clear!
  Monban.warden_config = Monban::WardenSetup.new(Monban.warden_config).call
  yield
ensure
  Monban.config = old_config
end
