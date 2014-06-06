require 'warden'

module Monban
  module Test
    module ControllerHelpers
      def self.included(base)
        base.class_eval do
          setup :store_controller_for_warden, :warden if respond_to?(:setup)
        end
      end

      def store_controller_for_warden
        @request.env['action_controller.instance'] = @controller
      end

      def sign_in(user)
        @controller.sign_in(user)
      end

      def sign_out
        @controller.sign_out
      end

      def warden
        @warden ||= begin
          manager = Warden::Manager.new(nil) do |config|
            config.merge! Monban.warden_config
          end
          @request.env['warden'] = Warden::Proxy.new(@request.env, manager)
        end
      end
    end
  end
end
