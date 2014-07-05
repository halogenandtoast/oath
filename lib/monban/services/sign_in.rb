module Monban
  # Sign in service. Signs the user in via warden
  # @since 0.0.15
  class SignIn
    # Initialize service
    #
    # @param user [User] A user object
    # @param warden [Warden] warden
    def initialize user, warden
      @user = user
      @warden = warden
    end

    # Perform the service
    def perform
      @warden.set_user(@user)
    end
  end
end
