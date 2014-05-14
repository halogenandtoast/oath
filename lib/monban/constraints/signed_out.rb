module Monban
  module Constraints
    class SignedOut
      def matches?(request)
        warden = request.env["warden"]
        warden && warden.unauthenticated?
      end
    end
  end
end
