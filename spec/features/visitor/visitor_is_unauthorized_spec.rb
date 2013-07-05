require 'spec_helper'

feature 'Visitor is unauthorzed' do
  scenario 'when visiting a resource' do
    visit failure_path
    expect(page.status_code).to eq(401)
  end
end
