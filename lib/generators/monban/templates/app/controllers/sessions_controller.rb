class SessionsController < ApplicationController
  respond_to :html

  def new
  end

  def create
    user = authenticate_session(session_params)
    sign_in(user) do
      respond_with(user, location: root_path) and return
    end
    render :new
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private

  def session_params
<% if config[:use_strong_parameters] -%>
    params.require(:session).permit(:email, :password)
<% else -%>
    params[:session]
<% end -%>
  end
end

