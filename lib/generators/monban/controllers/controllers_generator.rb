require 'rails/generators/base'

module Monban
  module Generators
    class ControllersGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
    end
  end
end
