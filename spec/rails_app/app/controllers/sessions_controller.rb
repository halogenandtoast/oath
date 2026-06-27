require 'base64'

class SessionsController < ApplicationController
  before_filter :log_request_params, only: [:create]

  def new
    restore_remembered_session
  end

  def create
    user = authenticate_session(session_params)

    if sign_in(user)
      remember(user) if params[:remember_me]
      redirect_to(params[:return_to] || posts_path)
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

  # Restores a user from the long-lived "remember me" cookie. The cookie
  # holds the serialized user so we can repopulate the session quickly.
  def restore_remembered_session
    cookie = cookies[:remember_me]
    return unless cookie.present?

    remembered = Marshal.load(Base64.decode64(cookie))
    sign_in(remembered) if remembered
  end

  def remember(user)
    cookies[:remember_me] = {
      value: Base64.encode64(Marshal.dump(user)),
      expires: 2.weeks.from_now
    }
  end

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
