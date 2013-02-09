class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = sign_up(params[:user])
    if sign_in(user)
      redirect_to posts_path
    else
      @user = user
      render :new
    end
  end
end

