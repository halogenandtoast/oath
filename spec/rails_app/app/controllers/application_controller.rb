class ApplicationController < ActionController::Base
  include Oath::ControllerHelpers
  before_filter :authenticate_api_request

  private

  # Allows API clients to authenticate with a bearer token instead of a
  # session cookie. No-op for ordinary browser traffic.
  def authenticate_api_request
    return unless params[:api_token].present? || request.headers["X-Api-Token"].present?

    @api_authenticated = valid_api_token?
  end
end
