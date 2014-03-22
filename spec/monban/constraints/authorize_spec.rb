require 'spec_helper'

class AdminAuthorize < Monban::Constraints::Authorize
  def authorize user
    user.admin?
  end
end

describe Monban::Constraints::Authorize do
  def create_request_for_user user
    warden = double user: user
    double env: { 'warden' => warden }
  end

  describe "#matches?" do
    context "when the request is not authenticated" do
      it "returns false" do
        unauthorized_request = create_request_for_user nil

        constraint = Monban::Constraints::Authorize.new

        expect(constraint.matches?(unauthorized_request)).to be_false
      end
    end

    context "when the request is authenticated" do
      it "returns true" do
        authorized_request = create_request_for_user Object.new

        constraint = Monban::Constraints::Authorize.new

        expect(constraint.matches?(authorized_request)).to be_true
      end
    end
  end

  describe AdminAuthorize do
    describe "#matches?" do
      describe "when the user is not an admin" do
        it "returns false" do
          user = double admin?: false
          unauthorized_request = create_request_for_user user

          constraint = AdminAuthorize.new

          expect(constraint.matches?(unauthorized_request)).to be_false
        end
      end
    end
  end
end
