module Monban
  module Strategies
    class PasswordStrategy < ::Warden::Strategies::Base
      def valid?
        params[:email] || params[:password]
      end

      def authenticate!
        user = Monban.user_class.find_by(email: params[:email])
        auth = Authentication.new(user, params[:password])
        auth.authenticated? ? success!(user) : fail!("Could not log in")
      end
    end
  end
end
