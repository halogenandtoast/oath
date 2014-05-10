ENV["RAILS_ENV"] = "test"
$LOAD_PATH.unshift File.dirname(__FILE__)

require 'rails_app/config/environment'
require 'rspec/rails'
require 'monban'
require 'capybara'

RSpec.configure do |config|
  config.include Warden::Test::Helpers
  config.order = "random"
end

def with_monban_config(hash, &block)
  old_config = {}
  hash.each do |key, value|
    old_config[key] = Monban.config.send(key)
    Monban.config.send(:"#{key}=", value)
  end

  yield

  old_config.each do |key, value|
    Monban.config.send(:"#{key}=", old_config[key])
  end
end
