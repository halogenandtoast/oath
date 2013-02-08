class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by_email(params[:session][:email])

    if authenticate(user, params[:session][:password])
      sign_in user
    else
      redirect_to root_path, notice: "Invalid email or password"
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
