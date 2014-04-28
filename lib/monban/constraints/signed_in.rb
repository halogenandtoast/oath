module Monban
  module Constraints
    class SignedIn
      def matches?(request)
        warden = request.env["warden"]
        warden && warden.authenticated?
      end
    end
  end
end
