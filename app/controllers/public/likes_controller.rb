class Public::LikesController < ApplicationController
  
  def index
    @user = User.find(params[:user_id])
    @works = @user.like_works.all
  end
  
  def create
    @work = Work.find(params[:work_id])
    like = current_user.likes.new(work_id: @work.id)
    like.save
  end
  
  def destroy
    @work = Work.find(params[:work_id])
    like = current_user.likes.find_by(work_id: @work.id)
    like.destroy
  end
  
end
