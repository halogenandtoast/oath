module Monban
  module Test
    # Helpers for integration or feature specs
    # @note these have only been tested with rspec integration and feature specs
    # @since 0.0.15
    module Helpers
      include Warden::Test::Helpers

      # Sign a user in
      # @param user [User] user to sign in
      def sign_in user
        login_as user
      end

      # Sign a user out
      def sign_out
        logout
      end
    end
  end
end
