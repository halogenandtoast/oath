require 'spec_helper'

module Monban
  describe FieldMap do
    it 'returns the params without a field map' do
      params = double()
      field_map = FieldMap.new(params, nil)
      expect(field_map.to_fields).to eq(params)
    end

    it 'returns mapped params with a field map' do
      params = { email_or_username: 'foo' }
      map = { email_or_username: [:email, :username] }
      field_map = FieldMap.new(params, map)
      expect(field_map.to_fields).to eq(["email = ? OR username = ?", 'foo', 'foo'])
    end
  end
end
