class FailuresController < ApplicationController
  def show
    render status: :unauthorized, text: "Unauthorized"
  end
end
