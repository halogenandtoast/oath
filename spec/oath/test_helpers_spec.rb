require 'spec_helper'
require 'warden'
require 'oath/test/helpers'

module Warden::Spec
  module Helpers
    FAILURE_APP = lambda{|e|[401, {"Content-Type" => "text/plain"}, ["You Fail!"]] }

    def env_with_params(path = "/", params = {}, env = {})
      method = params.delete(:method) || "GET"
      env = { 'HTTP_VERSION' => '1.1', 'REQUEST_METHOD' => "#{method}" }.merge(env)
      Rack::MockRequest.env_for("#{path}?#{Rack::Utils.build_query(params)}", env)
    end

    def setup_rack(app = nil, opts = {}, &block)
      app ||= block if block_given?

      opts[:failure_app]         ||= failure_app
      opts[:default_strategies]  ||= [:password]
      opts[:default_serializers] ||= [:session]
      blk = opts[:configurator] || proc{}

      Rack::Builder.new do
        use opts[:session] || Warden::Spec::Helpers::Session unless opts[:nil_session]
        use Warden::Manager, opts, &blk
        run app
      end
    end

    def valid_response
      Rack::Response.new("OK").finish
    end

    def failure_app
      Warden::Spec::Helpers::FAILURE_APP
    end

    def success_app
      lambda{|e| [200, {"Content-Type" => "text/plain"}, ["You Win"]]}
    end

    class Session
      attr_accessor :app
      def initialize(app,configs = {})
        @app = app
      end

      def call(e)
        e['rack.session'] ||= {}
        @app.call(e)
      end
    end # session
  end
end

module Oath
  module Test
    describe Helpers do
      include Oath::Test::Helpers
      include Warden::Spec::Helpers

      before { $captures = [] }
      after { Oath.test_reset! }

      it 'performs a sign in' do
        user = double(id: 1)
        return_value = sign_in(user)
        app = lambda do |env|
          $captures << :run
          expect(env['warden']).to be_authenticated
          expect(env['warden'].user).to eq(user)
          valid_response
        end
        setup_rack(app).call(env_with_params)

        expect(return_value).to eq(user)
        expect($captures).to eq([:run])
      end

      it 'performs a sign out' do
        user = double(id: 1)
        sign_in(user)
        sign_out

        app = lambda do |env|
          $captures << :run
          warden = env['warden']
          expect(warden.user).to be_nil
          expect(warden).not_to be_authenticated
        end

        setup_rack(app).call(env_with_params)
        expect($captures).to eq([:run])
      end
    end
  end
end
