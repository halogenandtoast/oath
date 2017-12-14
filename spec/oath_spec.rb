require 'spec_helper'
require 'warden'

describe 'Oath' do
  it "stores the warden config" do
    expect(Oath.warden_config).to be_a Warden::Config
  end

  it "provides a .test_mode!" do
    Oath.test_mode!
    expect(Oath.hash_token('password')).to eql('password')
    expect(Oath.compare_token('password', 'password')).to be_truthy
  end

  it "does not lookup with empty params" do
    allow(Oath::FieldMap).to receive(:new).and_return(fake_field_map)
    with_oath_config(find_method: -> (conditions) { raise }) do
      expect(-> { Oath.lookup({}, {}) }).not_to raise_exception
    end
  end

  def fake_field_map
    double(Oath::FieldMap).tap do |field_map|
      allow(field_map).to receive(:to_fields).and_return(["foo=1 OR bar=1"])
    end
  end
end
