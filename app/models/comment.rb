class Comment < ApplicationRecord
    
  belongs_to :user
  belongs_to :work
  
  has_many :notifications, dependent: :destroy
  has_many :reports
  
  validates :message, presence: true
  
  def create_notification_comment
    #１時間以内の同一ユーザーから同一投稿へのコメントは通知しない
    unless Notification.where(visitor_id: user_id, visited_id: work.user_id, work_id: work_id, action: "comment", created_at: 1.hour.ago...Time.now).present?
      @notification = self.user.notifications.new(
        visited_id: work.user_id,
        work_id: work_id,
        comment_id: id,
        action: 2
        )
        #自分のコメントは通知しない
        unless @notification.visitor_id == @notification.visited_id
          @notification.save
        end
    end
  end
  
  def reported_by?(current_user)
    reports.find_by(reporter_id: current_user.id).present?
  end
  
end
