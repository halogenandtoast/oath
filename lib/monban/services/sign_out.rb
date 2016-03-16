module Monban
  module Services
    # Sign out service. Signs the user out via warden
    # @since 0.0.15
    class SignOut
      # Initialize service
      #
      # @param warden [Warden] warden
      def initialize warden
        @warden = warden
        @user = warden.user
      end

      # Perform the service
      def perform
        warden.logout
      end

      private

      attr_reader :warden, :user
    end
  end
end
