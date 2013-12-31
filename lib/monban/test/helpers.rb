module Monban
  module Test
    module Helpers
      include Warden::Test::Helpers

      def sign_in user
        login_as user
      end

      def sign_out
        logout
      end
    end
  end
end
