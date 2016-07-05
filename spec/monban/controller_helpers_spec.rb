require 'spec_helper'
require 'warden'

module Monban
  describe ControllerHelpers do
    class WardenMock
      def user; end
    end
    class Flash < Struct.new(:notice)
    end
    class FakeRequest
      attr_reader :env
      def initialize(env)
        @env = env
      end
    end

    class Dummy
      attr_reader :redirected, :redirected_to, :flash, :request
      def initialize warden
        @warden = warden
        @flash = Flash.new
        @redirected = false
        @request = FakeRequest.new(env)
      end
      def redirect_to path
        @redirected = true
        @redirected_to = path
      end
      def env
        { "warden" => @warden }
      end
    end

    before(:each) do
      @warden = WardenMock.new
      @dummy = Dummy.new(@warden)
      @dummy.extend(ControllerHelpers)
    end

    it 'performs a sign in' do
      user = stub_sign_in
      @dummy.sign_in user
    end

    it 'runs the block when user is signed in' do
      user = stub_sign_in
      expectation = double()
      allow(expectation).to receive(:success)
      @dummy.sign_in(user) { expectation.success }
      expect(expectation).to have_received(:success)
    end

    it 'does not run the block when user can not be signed in' do
      user = stub_sign_in(false)
      expectation = double()
      allow(expectation).to receive(:failure)
      @dummy.sign_in(user) { expectation.failure }
      expect(expectation).not_to have_received(:failure)
    end

    it 'performs a sign out' do
      sign_out = double()
      allow(sign_out).to receive(:perform)
      allow(Services::SignOut).to receive(:new).with(@warden).and_return(sign_out)
      @dummy.sign_out
      expect(sign_out).to have_received(:perform)
    end

    it 'performs a sign_up' do
      user_params = stub_sign_up
      @dummy.sign_up user_params
    end

    it 'runs the block when user is signed up' do
      user_params = stub_sign_up
      expectation = double()
      allow(expectation).to receive(:success)
      @dummy.sign_up(user_params) { expectation.success }
      expect(expectation).to have_received(:success)
    end

    it 'does not run the block when user can not be signed up' do
      user_params = stub_sign_up(false)
      expectation = double()
      allow(expectation).to receive(:failure)
      @dummy.sign_up(user_params) { expectation.failure }
      expect(expectation).not_to have_received(:failure)
    end

    it 'authenticates a session' do
      session_params = { password: 'password', email: 'a@b.com' }
      user = double()
      authentication = double()
      allow(authentication).to receive(:perform).and_return(user)
      allow(Monban).to receive(:lookup).with({email: 'a@b.com'}, nil).and_return(user)
      allow(Services::Authentication).to receive(:new).with(user, 'password').and_return(authentication)
      expect(@dummy.authenticate_session(session_params)).to eq user
    end

    it 'authenticates a session against multiple fields' do
      session_params = { email_or_username: 'foo', password: 'password' }
      field_map = { email_or_username: [:email, :username] }
      user = double()
      authentication = double()
      allow(authentication).to receive(:perform).and_return(user)
      allow(Monban).to receive(:lookup).with(session_params.except(:password), field_map).and_return(user)
      allow(Services::Authentication).to receive(:new).with(user, 'password').and_return(authentication)
      expect(@dummy.authenticate_session(session_params, field_map)).to eq user
    end

    it 'returns false when it could not authenticate the user' do
      session_params = { password: "password", lookup_key: "lookup_key" }
      user = double()
      authentication = double()
      allow(authentication).to receive(:perform).and_return(false)
      allow(Monban).to receive(:lookup).with({ lookup_key: "lookup_key" }, nil).and_return(user)
      allow(Services::Authentication).to receive(:new).with(user, 'password').and_return(authentication)
      expect(@dummy.authenticate_session(session_params)).to be_falsey
    end

    it 'performs an authenticate' do
      user = double()
      password = double()
      authentication = double()
      allow(authentication).to receive(:perform)
      allow(Services::Authentication).to receive(:new).with(user, password).and_return(authentication)
      @dummy.authenticate user, password
      expect(authentication).to have_received(:perform)
    end

    it 'returns the current user' do
      current_user = double()
      allow(@warden).to receive(:user).and_return(current_user)
      expect(@dummy.current_user).to eq current_user
    end

    it 'returns signed_in?' do
      allow(@warden).to receive(:user)
      allow(@dummy).to receive(:current_user)
      @dummy.signed_in?
      expect(@warden).to have_received(:user)
      expect(@dummy).not_to have_received(:current_user)
    end

    it 'redirects when not signed_in' do
      allow(@warden).to receive(:user).and_return(false)
      @dummy.require_login
      expect(@dummy.redirected).to eq(true)
      expect(@dummy.redirected_to).to eq(Monban.config.no_login_redirect)
      expect(@dummy.flash.notice).to eq(Monban.config.sign_in_notice.call)
    end

    it 'does not redirect when signed_in' do
      allow(@warden).to receive(:user).and_return(true)
      @dummy.require_login
      expect(@dummy.redirected).to eq(false)
    end

    it 'returns warden' do
      expect(@dummy.warden).to eq @warden
    end

    def stub_sign_in(success = true)
      user = double()
      sign_in = double()
      allow(sign_in).to receive(:perform).and_return(success)
      allow(Services::SignIn).to receive(:new).with(user, @warden).and_return(sign_in)
      user
    end

    def stub_sign_up(success = true)
      user_params = double()
      sign_up = double()
      allow(sign_up).to receive(:perform).and_return(success)
      allow(Services::SignUp).to receive(:new).with(user_params).and_return(sign_up)
      user_params
    end
  end
end
