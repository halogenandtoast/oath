require "monban/version"
require "monban/configuration"
require "monban/services"
require "monban/controller_helpers"
require "monban/railtie"
require "monban/back_door"
require "monban/warden_setup"
require "monban/field_map"
require "monban/strategies/password_strategy"
require "active_support/core_ext/module/attribute_accessors"

module Monban
  mattr_accessor :warden_config
  mattr_accessor :config

  module Test
    autoload :Helpers, "monban/test/helpers"
    autoload :ControllerHelpers, "monban/test/controller_helpers"
  end

  def self.initialize warden_config, &block
    setup_config(&block)
    setup_warden_config(warden_config)
  end

  def self.compare_token(digest, token)
    config.token_comparison.call(digest, token)
  end

  def self.encrypt_token(token)
    config.encryption_method.call(token)
  end

  def self.user_class
    config.user_class.constantize
  end

  def self.lookup(params, field_map)
    fields = FieldMap.new(params, field_map).to_fields
    default_fields = { Monban.config.user_lookup_field => nil }
    self.config.find_method.call(default_fields.merge(fields))
  end

  def self.test_mode!
    Warden.test_mode!
    self.config ||= Monban::Configuration.new
    config.encryption_method = ->(password) { password }
    config.token_comparison = ->(digest, unencrypted_password) do
      digest == unencrypted_password
    end
  end

  def self.configure(&block)
    self.config ||= Monban::Configuration.new
    yield self.config
  end

  def self.test_reset!
    Warden.test_reset!
  end

  private

  def self.setup_config
    self.config ||= Monban::Configuration.new
    if block_given?
      yield config
    end
  end

  def self.setup_warden_config(warden_config)
    warden_config.failure_app = self.config.failure_app
    self.warden_config = warden_config
  end
end
