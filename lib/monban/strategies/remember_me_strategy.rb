require 'warden'

module Monban
  module Strategies
    # Strategy for setting a remember token and keeping the user signed in
    # between sessions
    class RememberMeStrategy < ::Warden::Strategies::Base

      # Checks if strategy should be executed
      # @return [Boolean]
      def valid?
        remember_me_cookie
      end

      # Authenticates the remember me token to sign in the user
      def authenticate!
        user = Monban.config.user_class.find_by(remember_me_token_field => remember_me_cookie)
        user ? success!(user) : fail!("Could not log in")
      end

      private

      def remember_me_token_field
        :id
      end

      def remember_me_cookie
        request.cookies["remember_me"].to_i
      end

    end
  end
end
