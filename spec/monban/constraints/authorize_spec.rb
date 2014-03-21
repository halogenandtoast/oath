require 'spec_helper'

class AdminAuthorize < Monban::Constraints::Authorize
  def authorize user
    user.admin?
  end
end

module Monban
  module Constraints
    describe Authorize do
      describe "#matches?" do
        context "when the request is unauthenticated" do
          it "throws back to warden" do
            warden = double(user: nil)
            unauthenticated_request = double(env: { 'warden' => warden })

            constraint = Authorize.new

            expect {
              constraint.matches? unauthenticated_request
            }.to throw_symbol :warden
          end
        end

        context "when the request is authenticated" do
          it "returns true" do
            warden = double(user: Object.new)
            authenticated_request = double(env: { 'warden' => warden })

            constraint = Authorize.new

            expect(constraint.matches?(authenticated_request)).to be_true
          end
        end
      end
    end

    describe AdminAuthorize do
      describe "when the user is not an admin" do
        it "throws back to warden" do
          warden = double(user: double(admin?: false))
          unauthenticated_request = double(env: { 'warden' => warden })

          constraint = AdminAuthorize.new

          expect {
            constraint.matches? unauthenticated_request
          }.to throw_symbol :warden
        end
      end
    end
  end
end

