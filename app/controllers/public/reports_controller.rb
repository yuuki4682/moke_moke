class Public::ReportsController < ApplicationController
  
  def report_work
    @work = Work.find(params[:work_id])
    @report = current_user.reports.new(reported_id: @work.user_id, work_id: @work.id)
    @report.reason = 0
    @report.save
  end

  def report_chat
    @chat = Chat.find(params[:chat_id])
    @report = current_user.reports.new(reported_id: @chat.user_id, chat_id: @chat.id)
    @report.reason = 1
    @report.save
  end

  def report_comment
    @comment = Comment.find(params[:comment_id])
    @report = current_user.reports.new(reported_id: @comment.user_id, comment_id: @comment.id)
    @report.reason = 2
    @report.save
  end

end
