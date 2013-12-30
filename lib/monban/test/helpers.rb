module Monban
  module Test
    module Helpers
      def warden
        @warden ||= Warden::Proxy.new({'rack.session' => {}}, manager)
      end

      def manager
        @manager ||= Warden::Manager.new(nil)
      end

      def sign_in user
        Monban.config.sign_in_service.new(user, warden).perform
      end

      def sign_out
        Monban.config.sign_out_service.new(warden).perform
      end

      def user
        warden.user
      end
    end
  end
end
