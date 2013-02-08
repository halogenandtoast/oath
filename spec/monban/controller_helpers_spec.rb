require 'spec_helper'

module Monban
  describe ControllerHelpers do
    class WardenMock
      def user; end
    end
    class Dummy
      attr_reader :redirected
      def initialize warden
        @warden = warden
        @redirected = false
      end
      def redirect_to path
        @redirected = true
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
      user = double()
      sign_in = double()
      sign_in.should_receive(:perform)
      SignIn.should_receive(:new).with(user, @warden).and_return(sign_in)
      @dummy.sign_in user
    end

    it 'performs a sign out' do
      sign_out = double()
      sign_out.should_receive(:perform)
      SignOut.should_receive(:new).with(@warden).and_return(sign_out)
      @dummy.sign_out
    end

    it 'performs a sign_up' do
      user_params = double()
      sign_up = double()
      sign_up.should_receive(:perform)
      SignUp.should_receive(:new).with(user_params).and_return(sign_up)
      @dummy.sign_up user_params
    end

    it 'performs an authenticate' do
      user = double()
      password = double()
      authentication = double()
      authentication.should_receive(:authenticated?)
      Authentication.should_receive(:new).with(user, password).and_return(authentication)
      @dummy.authenticate user, password
    end

    it 'returns the current user' do
      @warden.should_receive(:user)
      @dummy.current_user
    end

    it 'returns signed_in?' do
      @warden.should_receive(:user)
      @dummy.signed_in?
    end

    it 'redirects when not signed_in' do
      @warden.should_receive(:user).and_return(false)
      @dummy.require_login
      expect(@dummy.redirected).to eq(true)
    end

    it 'does not redirect when signed_in' do
      @warden.should_receive(:user).and_return(true)
      @dummy.require_login
      expect(@dummy.redirected).to eq(false)
    end

    it 'returns warden' do
      @dummy.warden.should == @warden
    end
  end
end

