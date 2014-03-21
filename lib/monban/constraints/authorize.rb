module Monban
  module Constraints
    class Authorize
      def matches? request
        user = current_user request
        unauthorized! unless user && authorize(user)
        true
      end

      protected
      def authorize user
        user
      end

      def current_user request
        request.env['warden'].user
      end

      def unauthorized!
        throw(:warden)
      end
    end
  end
end
