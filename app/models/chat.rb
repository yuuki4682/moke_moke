class Chat < ApplicationRecord
    
  belongs_to :user
  belongs_to :room
  has_many :user_rooms, through: :room
  has_many :notifications, dependent: :destroy
  has_many :reports
  
  validates :message, presence: true, length: { maximum: 50 } 
  
  def create_notification_chat
    #オブジェクトに紐づいる2つのuser_roomsからチャットの送信者ではないほうを取得
    visited_user_room = self.user_rooms.where.not(user_id: self.user_id)
    #user_roomからuser_idの値のみ取得
    visited = visited_user_room.pluck(:user_id)[0]
    
    @notification = self.user.notifications.new(
      visited_id: visited,
      chat_id: id,
      action: 1
      )
    @notification.save
    
  end

  def reported_by?(current_user)
    reports.find_by(reporter_id: current_user.id).present?
  end

end
