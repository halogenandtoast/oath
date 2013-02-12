class UsersController < ApplicationController
  respond_to :html

  def new
    @user = User.new
  end

  def create
    @user = sign_up(user_params)
    sign_in(@user)
    respond_with @user, location: root_path
  end

  private

  def user_params
<% if config[:use_strong_parameters] -%>
    params.require(:user).permit(:email, :password)
<% else -%>
    params[:user]
<% end -%>
  end
end

