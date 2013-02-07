require 'spec_helper'

describe 'Monban' do
  it "stores the warden config" do
    puts Monban.warden_config.inspect
  end
end
