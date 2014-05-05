require 'rails/generators/active_record'

module Monban
  module Generators
    class ScaffoldGenerator < Rails::Generators::Base
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

      def add_controllers
        template 'app/controllers/sessions_controller.rb', 'app/controllers/sessions_controller.rb'
        template 'app/controllers/users_controller.rb', 'app/controllers/users_controller.rb'
      end

      def add_helper_module_to_application_controller
        inject_into_class "app/controllers/application_controller.rb", ApplicationController, "  include Monban::ControllerHelpers\n"
      end

      def self.next_migration_number(dir)
        ActiveRecord::Generators::Base.next_migration_number(dir)
      end

      def add_model
        generate 'model', 'user email password_digest'
      end

      def display_readme
        readme 'scaffold_readme'
      end
    end
  end
end
