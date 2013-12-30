require 'spec_helper'
require 'monban/test/helpers'

module Monban
  module Test
    describe Helpers do
      class Dummy
        include Monban::Test::Helpers
      end

      it 'performs a sign in' do
        user = double(id: 1)
        dummy = Dummy.new
        dummy.sign_in user
        expect(dummy.warden.user).to eq(user)
      end

      it 'performs a sign out' do
        user = double(id: 1)
        dummy = Dummy.new
        dummy.sign_in user
        dummy.sign_out
        expect(dummy.warden.user).to eq(nil)
      end
    end
  end
end
