module Monban
  module Constraints
    class Authenticate
      def matches? request
        throw(:warden) unless request.env['warden'].user
        true
      end
    end
  end
end
