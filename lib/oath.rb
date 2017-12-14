require 'warden'
require "oath/version"
require "oath/configuration"
require "oath/services"
require "oath/controller_helpers"
require "oath/railtie"
require "oath/failure_app"
require "oath/back_door"
require "oath/warden_setup"
require "oath/field_map"
require "oath/param_transformer"
require "oath/strategies/password_strategy"
require "active_support/core_ext/module/attribute_accessors"

# Oath is an authentication toolkit designed to allow developers to create their own
# authentication solutions. If you're interested in a default implementation try
# {http://github.com/halogenandtoast/oath-generators Oath Generators}
# @since 0.0.15
module Oath
  mattr_accessor :warden_config
  mattr_accessor :config

  module Test
    autoload :Helpers, "oath/test/helpers"
    autoload :ControllerHelpers, "oath/test/controller_helpers"
  end

  # initialize Oath. Sets up warden and the default configuration.
  #
  # @note This is used in {Oath::Railtie} in order to bootstrap Oath
  # @param warden_config [Warden::Config] the configuration from warden
  # @see Oath::Railtie
  # @see Oath::Configuration
  def self.initialize warden_config
    setup_config
    setup_warden_config(warden_config)
  end

  # compares the token (undigested password) to a digested password
  #
  # @param digest [String] A digested password
  # @param token [String] An undigested password
  # @see Oath::Configuration#default_token_comparison
  # @return [Boolean] whether the token and digest match
  def self.compare_token(digest, token)
    config.token_comparison.call(digest, token)
  end

  # hashes a token
  #
  # @param token [String] the password in undigested form
  # @see Oath::Configuration#default_hashing_method
  # @return [String] a digest of the token
  def self.hash_token(token)
    config.hashing_method.call(token)
  end

  # performs transformations on params for signing up and
  # signing in
  #
  # @param params [Hash] hash of parameters to transform
  # @see Oath::Configuration#param_transofmrations
  # @return [Hash] hash with transformed parameters
  def self.transform_params(params)
    ParamTransformer.new(params, config.param_transformations).to_h
  end

  # the user class
  #
  # @see Oath::Configuration#setup_class_defaults
  # @deprecated Use Oath.config.user_class instead
  # @return [Class] the User class
  def self.user_class
    warn "#{Kernel.caller.first}: [DEPRECATION] " +
      'Accessing the user class through the Oath module is deprecated. Use Oath.config.user_class instead.'
    config.user_class
  end

  # finds a user based on their credentials
  #
  # @param params [Hash] a hash of user parameters
  # @param field_map [FieldMap] a field map in order to allow multiple lookup fields
  # @see Oath::Configuration#default_find_method
  # @return [User] if user is found
  # @return [nil] if no user is found
  def self.lookup(params, field_map)
    if params.present?
      fields = FieldMap.new(params, field_map).to_fields
      self.config.find_method.call(fields)
    end
  end

  # Puts oath into test mode. This will disable hashing passwords
  # @note You must call this if you want to use oath in your tests
  def self.test_mode!
    Warden.test_mode!
    self.config ||= Oath::Configuration.new
    config.hashing_method = ->(password) { password }
    config.token_comparison = ->(digest, undigested_password) do
      digest == undigested_password
    end
  end

  # Configures oath
  #
  # @yield [configuration] Yield the current configuration
  # @example A custom configuration
  #   Oath.configure do |config|
  #     config.user_lookup_field = :username
  #     config.user_token_store_field = :hashed_password
  #   end
  def self.configure(&block)
    self.config ||= Oath::Configuration.new
    yield self.config
  end

  # Resets oath in between tests.
  # @note You must call this between tests
  def self.test_reset!
    Warden.test_reset!
  end

  private

  def self.setup_config
    self.config ||= Oath::Configuration.new
  end

  def self.setup_warden_config(warden_config)
    self.warden_config = WardenSetup.new(warden_config).call
  end
end
