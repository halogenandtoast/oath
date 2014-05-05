require 'rails/generators/active_record'

module Monban
  module Generators
    class PasswordResetGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path("../../templates", __FILE__)

      def add_config_options
        %w(development test production).each do |env|
          host = ask("What is the host to use for #{env}?")
          application(%{config.action_mailer.default_url_options = { :host => "#{host}" }}, env: env)
        end
      end

      def add_routes
        route("resources :password_resets, only: [:new, :create]")
        route("resources :users, only: [:none] do\n    resources :password_resets, only: [:edit, :update]\n  end")
      end

      def add_views
        copy_file 'app/views/password_resets/create.html.erb'
        copy_file 'app/views/password_resets/edit.html.erb'
        copy_file 'app/views/password_resets/new.html.erb'
        copy_file 'app/views/password_reset_mailer/change_password.html.erb'
      end

      def add_mailers
        template 'app/mailers/password_reset_mailer.rb', 'app/mailers/password_reset_mailer.rb'
      end

      def add_controllers
        template 'app/controllers/password_resets_controller.rb', 'app/controllers/password_resets_controller.rb'
      end

      def self.next_migration_number(dir)
        ActiveRecord::Generators::Base.next_migration_number(dir)
      end

      def add_model
        template 'app/models/password_reset.rb', 'app/models/password_reset.rb'
        migration_template "db/migrate/create_password_resets.rb", "db/migrate/create_password_resets.rb"
      end

      def display_readme
        readme 'password_reset_readme'
      end
    end
  end
end
