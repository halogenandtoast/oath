require 'warden'

module Monban
  module Test
    # These are test helpers for controller specs
    # @note these have only been tested with rspec controller specs
    # @since 0.0.15
    module ControllerHelpers
      def self.included(base)
        base.class_eval do
          setup :store_controller_for_warden, :warden if respond_to?(:setup)
        end
      end

      # Signs a user in for tests
      # @param user [User] the user to sign in
      def sign_in(user)
        @controller.sign_in(user)
      end

      # Signs the user out in tests
      def sign_out
        @controller.sign_out
      end

      # A mock of warden for tests
      def warden
        @warden ||= begin
          manager = Warden::Manager.new(nil) do |config|
            config.merge! Monban.warden_config
          end
          @request.env['warden'] = Warden::Proxy.new(@request.env, manager)
        end
      end

      private
      def store_controller_for_warden
        @request.env['action_controller.instance'] = @controller
      end

    end
  end
end
