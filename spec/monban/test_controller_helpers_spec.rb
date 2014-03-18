require 'spec_helper'

class FakeRequest
  attr_reader :env
  def initialize
    @env = {}
  end
end

class FakeController
  attr_reader :user
  def sign_in(user)
    @user = user
  end

  def sign_out
    @user = nil
  end
end

class FakeSpec
  cattr_reader :setup_methods
  attr_reader :request, :controller
  def initialize(controller = FakeController.new)
    @request = FakeRequest.new
    @controller = controller
  end

  def self.setup(*methods)
    @@setup_methods = methods
  end
  include Monban::Test::ControllerHelpers
end

module Monban
  module Test
    describe ControllerHelpers do
      it 'sets up warden' do
        expect(FakeSpec.setup_methods).to eq([:store_controller_for_warden, :warden])
      end

      it 'creates a warden manager' do
        fake_spec = FakeSpec.new
        expect(fake_spec.warden).to be_a(Warden::Proxy)
      end

      it 'calls the sign in method on the controller' do
        controller = FakeController.new
        fake_spec = FakeSpec.new(controller)
        fake_spec.sign_in("user")
        expect(controller.user).to eq("user")
      end

      it 'calls the sign out method on the controller' do
        controller = FakeController.new
        fake_spec = FakeSpec.new(controller)
        fake_spec.sign_in("user")
        fake_spec.sign_out
        expect(controller.user).to eq(nil)
      end
    end
  end
end
