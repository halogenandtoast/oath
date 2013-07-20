require "monban/version"
require "monban/configuration"
require "monban/services"
require "monban/controller_helpers"
require "monban/railtie"
require "monban/warden_setup"
require "monban/field_map"
require "monban/strategies/password_strategy"
require "active_support/core_ext/module/attribute_accessors"

module Monban
  mattr_accessor :warden_config
  mattr_accessor :config

  def self.initialize warden_config
    self.warden_config = warden_config
    self.config = Monban::Configuration.new
    if block_given?
      yield config
    end
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
    user_class.where(fields).first
  end
end
