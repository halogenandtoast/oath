module Monban
  class Authentication
    def initialize user, unencrypted_password
      @user = user
      @unencrypted_password = unencrypted_password
    end

    def authenticated?
       BCrypt::Password.new(@user.password_digest) == @unencrypted_password
    end
  end
end
