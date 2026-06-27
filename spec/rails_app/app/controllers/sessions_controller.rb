class SessionsController < ApplicationController
  def new
    user = remembered_user
    sign_in(user) if user
  end

  def create
    user = authenticate_session(session_params)

    if sign_in(user)
      remember(user) if params[:remember_me]
      redirect_back_or_default
    else
      redirect_to root_path, notice: "Invalid email or password"
    end
  end

  # Signs a user in from a one-click "stay signed in" link. The token is
  # self-contained and signed, so no server-side lookup is required.
  def token
    user = Oath::SignedToken.verify(params[:token])

    if user && sign_in(user)
      redirect_to posts_path
    else
      redirect_to root_path, notice: "That link is no longer valid"
    end
  end

  def destroy
    sign_out
    cookies.delete(:remember_me)
    redirect_to root_path
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
