module Monban
  class Authentication
    def initialize user, unencrypted_password
      @user = user
      @unencrypted_password = unencrypted_password
    end

    def authenticated?
      Monban.compare_password(@user.password_digest, @unencrypted_password)
    end
  end
end
