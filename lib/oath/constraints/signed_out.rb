module Oath
  module Constraints
    # Rails route constraint for signed out users
    class SignedOut
      # Checks to see if the constraint is matched by not having a user signed in
      #
      # @param request [Rack::Request] A rack request
      def matches?(request)
        warden = request.env["warden"]
        warden && warden.unauthenticated?
      end
    end
  end
end
