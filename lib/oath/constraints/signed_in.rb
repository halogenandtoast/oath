module Oath
  module Constraints
    # Rails route constraint for signed in users
    class SignedIn
      # Checks to see if the constraint is matched by having a user signed in
      #
      # @param request [Rack::Request] A rack request
      def matches?(request)
        warden = request.env["warden"]
        warden && warden.authenticated?
      end
    end
  end
end
