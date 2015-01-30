module Monban
  module Services
    # Sign up service. Signs the user up
    # @since 0.0.15
    class SignUp
      # Initialize service
      #
      # @param user_params [Hash] A hash of user credentials. Should contain the lookup and token fields
      def initialize user_params
        digested_token = token_digest(user_params)
        @user_params = user_params.
          except(token_field).
          merge(token_store_field.to_sym => digested_token)
      end

      # Performs the service
      # @see Monban::Configuration.default_creation_method
      def perform
        Monban.config.creation_method.call(@user_params.to_hash)
      end

      private

      def token_digest(user_params)
        undigested_token = user_params[token_field]
        unless undigested_token.blank?
          Monban.hash_token(undigested_token)
        end
      end

      def token_store_field
        Monban.config.user_token_store_field
      end

      def token_field
        Monban.config.user_token_field
      end
    end
  end
end
