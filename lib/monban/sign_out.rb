module Monban
  class SignOut
    def initialize cookies
      @cookies = cookies
    end

    def perform
      @cookies.delete(:user_id)
    end
  end
end
