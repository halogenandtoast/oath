require 'rails/generators/base'

module Monban
  module Generators
    class ControllersGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def copy_controllers
        copy_file 'sessions_controller.rb', 'app/controllers/session_controller.rb'
        copy_file 'users_controller.rb', 'app/controllers/users_controller.rb'
      end

      def add_routes
        route("resources :users, only: [:new, :create]")
        route("resource :session, only: [:new, :create, :destroy]")
      end

      def add_views
        copy_file 'views/users/new.html.erb', 'app/views/users/new.html.erb'
        copy_file 'views/sessions/new.html.erb', 'app/views/sessions/new.html.erb'
      end
    end
  end
end
