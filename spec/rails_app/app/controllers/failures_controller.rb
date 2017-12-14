class FailuresController < ApplicationController
  def show
    render status: :unauthorized, plain: "Unauthorized"
  end
end
