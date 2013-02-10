require 'rails/generators/active_record'
require 'generators/monban/controllers/controllers_generator'

module Monban
  module Generators
    class ScaffoldGenerator < ControllersGenerator
      include Rails::Generators::Migration
      source_root File.expand_path("../../templates", __FILE__)

      def add_routes
        route("resources :users, only: [:new, :create]")
        route("resource :session, only: [:new, :create, :destroy]")
      end

      def add_views
        copy_file 'app/views/users/new.html.erb'
        copy_file 'app/views/sessions/new.html.erb'
      end

      def copy_migration
        migration_template 'db/migrate/create_users.rb'
      end

      def add_helper_module_to_application_controller
        inject_into_class "app/controllers/application_controller.rb", ApplicationController, "  include Monban::ControllerHelpers\n"
      end

      def self.next_migration_number(dir)
        ActiveRecord::Generators::Base.next_migration_number(dir)
      end

      def add_model
        template 'app/models/user.rb', 'app/models/user.rb', config
      end
    end
  end
end
