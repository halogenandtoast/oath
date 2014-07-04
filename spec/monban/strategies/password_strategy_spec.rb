require 'spec_helper'

module Monban
  module Strategies
    describe PasswordStrategy do
      it "bases lookup and token on config values" do
        params = HashWithIndifferentAccess.new(username: 'test', the_password: 'password')

        with_monban_config(user_lookup_field: "username", user_token_field: "the_password") do
          env = Rack::MockRequest.env_for("/", params: params)
          strategy = PasswordStrategy.new(env)
          expect(strategy).to be_valid
        end
      end

      it "it doesn't trigger if params are not provided" do
        env = Rack::MockRequest.env_for("/")
        strategy = PasswordStrategy.new(env)
        expect(strategy).not_to be_valid
      end
    end
  end
end
