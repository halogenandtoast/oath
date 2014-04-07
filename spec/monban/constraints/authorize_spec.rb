require 'spec_helper'

describe Monban::Constraints::Authorize do
  def create_request_for_user user
    warden = double user: user
    double env: { 'warden' => warden }
  end

  def create_admin_authorizer
    ->(user) { user.admin? }
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

    context "when a custom authorizer is given" do
      context "and the request is not authenticated" do
        it "returns false" do
          unauthorized_request = create_request_for_user nil
          constraint = Monban::Constraints::Authorize.new(create_admin_authorizer)
          expect(constraint.matches?(unauthorized_request)).to be_false
        end
      end

      context "and the request is authenticated and authorized" do
        it "returns true" do
          authorized_request = create_request_for_user double(admin?: true)
          constraint = Monban::Constraints::Authorize.new(create_admin_authorizer)
          expect(constraint.matches?(authorized_request)).to be_true
        end
      end

      context "and the request is authenticated and unauthorized" do
        it "returns false" do
          unauthorized_request = create_request_for_user double(admin?: false)
          constraint = Monban::Constraints::Authorize.new(create_admin_authorizer)
          expect(constraint.matches?(unauthorized_request)).to be_false
        end
      end
    end
  end
end
