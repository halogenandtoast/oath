require 'warden'

module Monban
  module Strategies
    class PasswordStrategy < ::Warden::Strategies::Base
      def valid?
        lookup_field_value || token_field_value
      end

      def authenticate!
        user = Monban.user_class.find_by(lookup_field => lookup_field_value)
        auth = Authentication.new(user, token_field_value)
        auth.authenticated? ? success!(user) : fail!("Could not log in")
      end

      private

      def lookup_field_value
        params[lookup_field]
      end

      def token_field_value
        params[token_field]
      end

      def lookup_field
        Monban.config.user_lookup_field
      end

      def token_field
        Monban.config.user_token_field
      end
    end
  end
end
