class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = sign_up(params[:user])
    if @user
      sign_in(@user)
      redirect_to posts_path
    else
      render :new
    end
  end
end
