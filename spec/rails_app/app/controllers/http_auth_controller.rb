class HttpAuthController < ApplicationController
  skip_before_action :require_login
  http_basic_authenticate_with name: "username", password: "password"

  def index
    render text: "Success"
  end
end
