require 'spec_helper'
require 'monban/test/helpers'

module Monban
  module Test
    describe Helpers do
      class Dummy
        include Monban::Test::Helpers
      end

      it 'performs a sign in' do
        user = double()
        Dummy.new.sign_in user
        expect(Warden.user).to eq(user)
      end

      it 'performs a sign out' do
        user = double()
        dummy = Dummy.new
        dummy.sign_in user
        dummy.sign_out
        expect(Warden.user).to be_nil
      end
    end
  end
end
