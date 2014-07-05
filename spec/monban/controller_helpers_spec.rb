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
      expectation.should_receive(:success)
      @dummy.sign_in(user) { expectation.success }
    end

    it 'does not run the block when user can not be signed in' do
      user = stub_sign_in(false)
      expectation = double()
      expectation.should_not_receive(:failure)
      @dummy.sign_in(user) { expectation.failure }
    end

    it 'performs a sign out' do
      sign_out = double()
      sign_out.should_receive(:perform)
      Services::SignOut.should_receive(:new).with(@warden).and_return(sign_out)
      @dummy.sign_out
    end

    it 'performs a sign_up' do
      user_params = stub_sign_up
      @dummy.sign_up user_params
    end

    it 'runs the block when user is signed up' do
      user_params = stub_sign_up
      expectation = double()
      expectation.should_receive(:success)
      @dummy.sign_up(user_params) { expectation.success }
    end

    it 'does not run the block when user can not be signed up' do
      user_params = stub_sign_up(false)
      expectation = double()
      expectation.should_not_receive(:failure)
      @dummy.sign_up(user_params) { expecation.failure }
    end

    it 'authenticates a session' do
      session_params = { password: 'password', email: 'a@b.com' }
      user = double()
      authentication = double()
      authentication.should_receive(:perform).and_return(user)
      Monban.should_receive(:lookup).with({email: 'a@b.com'}, nil).and_return(user)
      Services::Authentication.should_receive(:new).with(user, 'password').and_return(authentication)
      @dummy.authenticate_session(session_params).should == user
    end

    it 'authenticates a session against multiple fields' do
      session_params = { email_or_username: 'foo', password: 'password' }
      field_map = { email_or_username: [:email, :username] }
      user = double()
      authentication = double()
      authentication.should_receive(:perform).and_return(user)
      Monban.should_receive(:lookup).with(session_params.except(:password), field_map).and_return(user)
      Services::Authentication.should_receive(:new).with(user, 'password').and_return(authentication)
      @dummy.authenticate_session(session_params, field_map).should == user
    end

    it 'returns false when it could not authenticate the user' do
      session_params = double()
      session_params.should_receive(:fetch).with(:password).and_return('password')
      session_params.should_receive(:except).with(:password).and_return(session_params)
      user = double()
      authentication = double()
      authentication.should_receive(:perform).and_return(false)
      Monban.should_receive(:lookup).with(session_params, nil).and_return(user)
      Services::Authentication.should_receive(:new).with(user, 'password').and_return(authentication)
      @dummy.authenticate_session(session_params).should == false
    end

    it 'performs an authenticate' do
      user = double()
      password = double()
      authentication = double()
      authentication.should_receive(:perform)
      Services::Authentication.should_receive(:new).with(user, password).and_return(authentication)
      @dummy.authenticate user, password
    end

    it 'returns the current user' do
      @warden.should_receive(:user)
      @dummy.current_user
    end

    it 'returns signed_in?' do
      @warden.should_receive(:user)
      @dummy.should_not_receive(:current_user)
      @dummy.signed_in?
    end

    it 'redirects when not signed_in' do
      @warden.should_receive(:user).and_return(false)
      @dummy.require_login
      expect(@dummy.redirected).to eq(true)
      expect(@dummy.redirected_to).to eq(Monban.config.no_login_redirect)
      expect(@dummy.flash.notice).to eq(Monban.config.sign_in_notice)
    end

    it 'does not redirect when signed_in' do
      @warden.should_receive(:user).and_return(true)
      @dummy.require_login
      expect(@dummy.redirected).to eq(false)
    end

    it 'returns warden' do
      @dummy.warden.should == @warden
    end

    def stub_sign_in(success = true)
      user = double()
      sign_in = double()
      sign_in.should_receive(:perform).and_return(success)
      Services::SignIn.should_receive(:new).with(user, @warden).and_return(sign_in)
      user
    end

    def stub_sign_up(success = true)
      user_params = double()
      sign_up = double()
      sign_up.should_receive(:perform).and_return(success)
      Services::SignUp.should_receive(:new).with(user_params).and_return(sign_up)
      user_params
    end
  end
end
