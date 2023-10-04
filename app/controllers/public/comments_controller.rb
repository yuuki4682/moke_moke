class Public::CommentsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @work = Work.find(params[:work_id])
    @comment = current_user.comments.new(comment_params)
    @comment.work_id = @work.id
    
    #自然言語処理APIによる感情分析（-1.0~1.0）
    @comment.score = Language.get_data(comment_params[:message])
    
    #感情分析のスコアが0以下の場合投稿不可
    unless @comment.score <= 0
      
      if @comment.save
        @comment.create_notification_comment
        redirect_to request.referer
      else
        render 'public/works/show'
      end
    else
      flash[:alert] = 'ネガティブな文章は送信できません。'
      redirect_to request.referer
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
