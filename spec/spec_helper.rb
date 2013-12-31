ENV["RAILS_ENV"] = "test"
$LOAD_PATH.unshift File.dirname(__FILE__)

require 'rails_app/config/environment'
require 'rspec/rails'
require 'monban'
require 'capybara'

RSpec.configure do |config|
  config.include Warden::Test::Helpers
end
