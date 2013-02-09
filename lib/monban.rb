require "pry"
require "monban/version"
require "monban/configuration"
require "monban/controller_helpers"
require "monban/railtie"
require "monban/warden_setup"
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

  def self.compare_password(digest, password)
    config.password_comparison.call(digest, password)
  end

  def self.encrypt_password(password)
    config.encryption_method.call(password)
  end

  def self.user_class
    config.user_class.constantize
  end
end
