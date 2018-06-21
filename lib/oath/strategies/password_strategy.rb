require 'warden'

module Oath
  module Strategies
    # Password strategy for warden
    # @since 0.0.15
    class PasswordStrategy < ::Warden::Strategies::Base

      # Checks if strategy should be executed
      # @return [Boolean]
      def valid?
        lookup_field_value || token_field_value
      end


      # Authenticates for warden
      def authenticate!
        user = Oath.config.user_class.find_by(lookup_field => lookup_field_value)
        auth = Oath.config.authentication_service.new(user, token_field_value)
        auth.perform ? success!(user) : fail!("Could not log in")
      end

      private

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
