class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = sign_up(user_params)

    if @user.valid?
      sign_in(@user)
      notify(@user, "Welcome to the app")
      redirect_to posts_path
    else
      render :new
    end
  end
end
