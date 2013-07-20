module Monban
  class SignOut
    def initialize warden
      @warden = warden
    end

    def perform
      @warden.logout
    end
  end
end
