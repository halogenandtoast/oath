class SessionsController < ApplicationController
  def new; end

  def create
    user = User.where(email: params[:session][:email]).first

    if authenticate(user, params[:session][:password])
      sign_in user
      redirect_to posts_path
    else
      redirect_to root_path, notice: "Invalid email or password"
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
