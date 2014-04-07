module Monban
  module Constraints
    class Authorize
      def initialize authorizer = nil
        @authorizer = authorizer || default_authorizer
      end

      def matches? request
        user = current_user request
        user && @authorizer.call(user)
      end

      protected
      def current_user request
        request.env['warden'].user
      end

      def default_authorizer
        ->(user) { user }
      end
    end
  end
end
