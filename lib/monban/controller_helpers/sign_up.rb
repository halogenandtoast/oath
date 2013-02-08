module Monban
  class SignUp
    def initialize user_params
      @email = user_params[:email]
      @password_digest = BCrypt::Password.create(user_params[:password])
    end

    def perform
      User.create(email: @email, password_digest: @password_digest)
    end
  end
end
