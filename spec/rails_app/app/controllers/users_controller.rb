class UsersController < ApplicationController
  respond_to :html

  def new
    @user = User.new
  end

  def create
    @user = sign_up(user_params)

    if @user.valid?
      sign_in(@user)
      redirect_to posts_path
    else
      render :new
    end
  end

  private

  def user_params
    params[:user]
  end
end

