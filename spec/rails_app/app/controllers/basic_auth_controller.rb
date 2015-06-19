class BasicAuthController < ApplicationController
  http_basic_authenticate_with name: "admin", password: "password"

  def show
    render plain: "Hello"
  end
end
