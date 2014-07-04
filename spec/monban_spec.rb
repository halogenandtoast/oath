require 'spec_helper'
require 'warden'

describe 'Monban' do
  it "stores the warden config" do
    expect(Monban.warden_config).to be_a Warden::Config
  end

  it "provides a .test_mode!" do
    Monban.test_mode!
    expect(Monban.hash_token('password')).to eql('password')
    expect(Monban.compare_token('password', 'password')).to be_true
  end

  it "allows lookup with a field_map" do
    allow(Monban::FieldMap).to receive(:new).and_return(fake_field_map)
    with_monban_config(find_method: -> (conditions) { true }) do
      expect(-> { Monban.lookup({}, {}) }).not_to raise_exception
    end
  end

  def fake_field_map
    double(Monban::FieldMap).tap do |field_map|
      allow(field_map).to receive(:to_fields).and_return(["foo=1 OR bar=1"])
    end
  end
end
