class Public::LikesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @user = User.find(params[:user_id])
    works = @user.like_works.order(created_at: :desc)
    @works = Kaminari.paginate_array(works).page(params[:page]).per(5)
  end
  
  def create
    @work = Work.find(params[:work_id])
    like = current_user.likes.new(work_id: @work.id)
    like.save
    @work.create_notification_like(current_user)
  end
  
  def destroy
    @work = Work.find(params[:work_id])
    like = current_user.likes.find_by(work_id: @work.id)
    like.destroy
  end
  
end
