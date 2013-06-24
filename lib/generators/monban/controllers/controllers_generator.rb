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
        if rails4? || strong_parameters_gem?
          true
        else
          yes?("Using strong_parameters?")
        end
      end

      def strong_parameters_gem?
        Kernel.const_defined?("StrongParameters")
      end

      def rails4?
         Rails::VERSION::MAJOR == 4
      end
    end
  end
end
