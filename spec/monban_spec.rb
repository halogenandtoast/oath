require 'spec_helper'

describe 'Monban' do
  it "stores the warden config" do
    expect(Monban.warden_config).to be_a Warden::Config
  end

  it "provides a .test_mode!" do
    Monban.test_mode!
    expect(Monban.encrypt_token('password')).to eql('password')
    expect(Monban.compare_token('password', 'password')).to be_true
  end
end
