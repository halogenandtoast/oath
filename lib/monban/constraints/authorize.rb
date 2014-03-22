module Monban
  module Constraints
    class Authorize
      def matches? request
        user = current_user request
        user && authorize(user)
      end

      protected
      def authorize user
        user
      end

      def current_user request
        request.env['warden'].user
      end
    end
  end
end
