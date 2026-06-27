class ApplicationController < ActionController::Base
  include Oath::ControllerHelpers
  protect_from_forgery with: :null_session

  def log_request_params
    logger.info "Request params: #{params.to_unsafe_h.inspect}"
  end
end
