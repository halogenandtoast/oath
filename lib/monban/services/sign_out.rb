module Monban
  # Sign out service. Signs the user out via warden
  # @since 0.0.15
  class SignOut
    # Initialize service
    #
    # @param warden [Warden] warden
    def initialize warden
      @warden = warden
    end

    # Perform the service
    def perform
      @warden.logout
    end
  end
end
