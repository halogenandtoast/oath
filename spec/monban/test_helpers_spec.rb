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
        dummy = sign_in(user)
        expect(dummy.user).to eq(user)
      end

      it 'performs a sign out' do
        dummy = sign_in
        dummy.sign_out
        expect(dummy.user).to eq(nil)
      end

      def sign_in(user = double(id: 1))
        Dummy.new.tap do |dummy|
          dummy.sign_in user
        end
      end
    end
  end
end
