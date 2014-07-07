require 'spec_helper'
require 'warden'

module Monban
  describe Configuration do
    it 'sets the no login redirect to a resonable default' do
      configuration = Configuration.new
      expect(configuration.no_login_redirect).to eq({ controller: "/sessions", action: "new" })
    end
  end
end
