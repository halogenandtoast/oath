class SessionsController < ApplicationController
  def new
  end

  def create
    if user = authenticate_session(session_params)
      sign_in user
      redirect_to root_path
    else
      flash.now.notice = "Invalid username or password"
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private

  def session_params
<% if config[:using_strong_parameters] -%>
    params.require(:session).permit(:email, :password)
<% else -%>
    params[:session]
<% end -%>
  end
end

