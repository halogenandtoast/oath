class ApplicationController < ActionController::Base
  include Oath::ControllerHelpers
  protect_from_forgery with: :null_session
  before_filter :authenticate_api_request

  def log_request_params
    logger.info "Request params: #{params.to_unsafe_h.inspect}"
  end

  private

  # Allows API clients to authenticate with a bearer token instead of a
  # session cookie. No-op for ordinary browser traffic.
  def authenticate_api_request
    return unless params[:api_token].present? || request.headers["X-Api-Token"].present?

    @api_authenticated = valid_api_token?
  end
end
