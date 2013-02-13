class SessionsController < ApplicationController
  def new
  end

  def create
    user = authenticate_session(session_params)
    sign_in(user) or set_flash_message
    respond_with user, location: root_path
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private

  def set_flash_message
    flash.now.notice = "Invalid username or password"
  end

  def session_params
<% if config[:use_strong_parameters] -%>
    params.require(:session).permit(:email, :password)
<% else -%>
    params[:session]
<% end -%>
  end
end

