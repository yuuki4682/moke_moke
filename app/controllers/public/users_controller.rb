class Public::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :is_matching_login_user, only: [:edit]
  
  def mypage
    @user = current_user
    @works = current_user.works
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to mypage_path
    else
      render :edit
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
  
  def is_matching_login_user
    user = User.find(params[:id])
    unless user == current_user
      redirect_to mypage_path
    end
  end
  
  
end
