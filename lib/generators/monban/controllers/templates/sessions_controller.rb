class SessionsController < ApplicationController
  def new
  end

  def create
    if user = authenticate_session(params[:session])
      sign_in user
      redirect_to posts_path
    else
      redirect_to root_path, notice: "Invalid username or password"
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end

