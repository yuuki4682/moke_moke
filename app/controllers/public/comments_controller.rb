class Public::CommentsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @work = Work.find(params[:work_id])
    @comment = current_user.comments.new(comment_params)
    @comment.work_id = @work.id
    if @comment.save
      @comment.create_notification_comment
      redirect_to request.referer
    else
      render 'public/works/show'
    end
  end
  
  def destroy
    work = Work.find(params[:work_id])
    comment = current_user.comments.find_by(work_id: work)
    comment.destroy
    redirect_to request.referer
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:message)
  end
  
end
