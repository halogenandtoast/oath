require 'warden'

module Monban
  module Strategies
    # Strategy for setting a remember token and keeping the user signed in
    # between sessions
    class RememberMeStrategy < ::Warden::Strategies::Base

      # Checks if strategy should be executed
      # @return [Boolean]
      def valid?
        binding.pry
        remember_me_cookie
      end

      # Authenticates the remember me token to sign in the user
      def authenticate!
        binding.pry
        user = Monban.config.user_class.find_by(remember_me_token_field => remember_me_token)
        user ? success!(user) : fail!("Could not log in")
      end

      private

      def remember_me_token_field
        id
      end

      def remember_me_token
        cookies["remember_me"]
      end

    end
  end
end
