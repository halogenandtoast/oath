class MultipleAttributesSessionsController < ApplicationController
  def new
  end

  def create
    user = authenticate_session(
      session_params,
      email_or_username: [:email, :email_or_username],
    )

    if sign_in(user)
      redirect_to posts_path
    else
      redirect_to root_path, notice: "Invalid email or password"
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private

  def session_params
    params.require(:session).permit(:email_or_username, :password)
  end
end
