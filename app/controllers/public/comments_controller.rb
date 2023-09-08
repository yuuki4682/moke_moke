class Public::CommentsController < ApplicationController
  
  def create
    work = Work.find(params[:work_id])
    comment = current_user.comments.new(comment_params)
    comment.work_id = work.id
    comment.save
    redirect_to request.referer
  end
  
  def destroy
    work = Work.find(params[:work_id])
    comment = current_user.comment.find_by(work_id: work)
    comment.destroy
    redirect_to request.referer
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:message)
  end
  
end
