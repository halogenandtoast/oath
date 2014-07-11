require 'warden'
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

# Monban is an authentication toolkit designed to allow developers to create their own
# authentication solutions. If you're interested in a default implementation try
# {http://github.com/halogenandtoast/monban-generators Monban Generators}
# @since 0.0.15
module Monban
  mattr_accessor :warden_config
  mattr_accessor :config

  module Test
    autoload :Helpers, "monban/test/helpers"
    autoload :ControllerHelpers, "monban/test/controller_helpers"
  end

  # initialize Monban. Sets up warden and the default configuration.
  #
  # @note This is used in {Monban::Railtie} in order to bootstrap Monban
  # @param warden_config [Warden::Config] the configuration from warden
  # @see Monban::Railtie
  # @see Monban::Configuration
  def self.initialize warden_config
    setup_config
    setup_warden_config(warden_config)
  end

  # compares the token (undigested password) to a digested password
  #
  # @param digest [String] A digested password
  # @param token [String] An undigested password
  # @see Monban::Configuration#default_token_comparison
  # @return [Boolean] whether the token and digest match
  def self.compare_token(digest, token)
    config.token_comparison.call(digest, token)
  end

  # hashes a token
  #
  # @param token [String] the password in undigested form
  # @see Monban::Configuration#default_hashing_method
  # @return [String] a digest of the token
  def self.hash_token(token)
    config.hashing_method.call(token)
  end

  # the user class
  #
  # @see Monban::Configuration#setup_class_defaults
  # @deprecated Use Monban.config.user_class instead
  # @return [Class] the User class
  def self.user_class
    warn "#{Kernel.caller.first}: [DEPRECATION] " +
      'Accessing the user class through the Monban module is deprecated. Use Monban.config.user_class instead.'
    config.user_class
  end

  # finds a user based on their credentials
  #
  # @param params [Hash] a hash of user parameters
  # @param field_map [FieldMap] a field map in order to allow multiple lookup fields
  # @see Monban::Configuration#default_find_method
  # @return [User] if user is found
  # @return [nil] if no user is found
  def self.lookup(params, field_map)
    fields = FieldMap.new(params, field_map).to_fields
    self.config.find_method.call(fields)
  end

  # Puts monban into test mode. This will disable hashing passwords
  # @note You must call this if you want to use monban in your tests
  def self.test_mode!
    Warden.test_mode!
    self.config ||= Monban::Configuration.new
    config.hashing_method = ->(password) { password }
    config.token_comparison = ->(digest, undigested_password) do
      digest == undigested_password
    end
  end

  # Configures monban
  #
  # @yield [configuration] Yield the current configuration
  # @example A custom configuration
  #   Monban.configure do |config|
  #     config.user_lookup_field = :username
  #     config.user_token_store_field = :hashed_password
  #   end
  def self.configure(&block)
    self.config ||= Monban::Configuration.new
    yield self.config
  end

  # Resets monban in between tests.
  # @note You must call this between tests
  def self.test_reset!
    Warden.test_reset!
  end

  private

  def self.setup_config
    self.config ||= Monban::Configuration.new
  end

  def self.setup_warden_config(warden_config)
    self.warden_config = WardenSetup.new(warden_config).call
  end
end
