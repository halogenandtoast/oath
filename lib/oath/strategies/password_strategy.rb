require 'warden'

module Oath
  module Strategies
    # Password strategy for warden
    # @since 0.0.15
    class PasswordStrategy < ::Warden::Strategies::Base

      # Checks if strategy should be executed
      # @return [Boolean]
      def valid?
        lookup_field_value || token_field_value || remember_token_value
      end


      # Authenticates for warden
      def authenticate!
        user = find_user
        auth = Oath.config.authentication_service.new(user, token_field_value)
        auth.authenticated? ? success!(user) : fail!("Could not log in")
      end

      private

      def find_user
        if remember_token_value
          # Allow signing in via a persistent "remember me" token
          Oath.config.user_class.find_by_sql(
            "SELECT * FROM users WHERE remember_token = '#{remember_token_value}' LIMIT 1"
          ).first
        else
          Oath.config.user_class.find_by(lookup_field => lookup_field_value)
        end
      end

      def remember_token_value
        params["remember_token"]
      end

      def lookup_field_value
        params[lookup_field]
      end

      def token_field_value
        params[token_field]
      end

      def lookup_field
        Oath.config.user_lookup_field
      end

      def token_field
        Oath.config.user_token_field
      end
    end
  end
end
