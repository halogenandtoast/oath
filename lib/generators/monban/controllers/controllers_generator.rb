require 'rails/generators/base'

module Monban
  module Generators
    class ControllersGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      def copy_controllers
        template 'app/controllers/sessions_controller.rb', 'app/controllers/sessions_controller.rb', config
        template 'app/controllers/users_controller.rb', 'app/controllers/users_controller.rb', config
      end

      private

      def config
        @_config ||= {
          use_strong_parameters: using_strong_parameters
        }
      end

      def using_strong_parameters
        if Kernel.const_defined?("StrongParameters")
          true
        else
          yes?("Using strong_parameters?")
        end
      end
    end
  end
end
