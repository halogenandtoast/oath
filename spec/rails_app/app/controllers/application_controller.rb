class ApplicationController < ActionController::Base
  include Monban::ControllerHelpers
  protect_from_forgery
end
