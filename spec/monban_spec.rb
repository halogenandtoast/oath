require 'spec_helper'

describe 'Monban' do
  it "stores the warden config" do
    expect(Monban.warden_config).to be_a Warden::Config
  end
end
