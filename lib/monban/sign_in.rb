module Monban
  class SignIn
    def initialize user, cookies
      @user = user
      @cookies = cookies
    end

    def perform
      if @user
        @cookies.signed[:user_id] = @user.id
      end
    end
  end
end
