class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = sign_up(user_params)
    if sign_in(user)
      redirect_to root_path
    else
      @user = user
      render :new
    end
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

