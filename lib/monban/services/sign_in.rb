module Monban
  class SignIn
    def initialize user, warden
      @user = user
      @warden = warden
    end

    def perform
      @warden.set_user(@user)
    end
  end
end
