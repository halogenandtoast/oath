require "monban/version"
require "monban/controller_helpers"
require "active_support/core_ext/module/attribute_accessors"

module Monban
  mattr_accessor :warden_config
end
