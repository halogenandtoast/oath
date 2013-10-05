module Monban
  module Test
    module Helpers
      def warden
        @warden ||= begin
          manager = Warden::Manager.new(nil)
          @request.env['warden'] = Warden::Proxy.new(@request.env, manager)
        end
      end

      def sign_in user
        Monban.config.sign_in_service.new(user, warden).perform
      end

      def sign_out
        Monban.config.sign_out_service.new(warden).perform
      end
    end
  end
end
