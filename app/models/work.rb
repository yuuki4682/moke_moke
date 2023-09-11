class Work < ApplicationRecord
  
  belongs_to :user
  
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  has_many :work_tags, dependent: :destroy
  has_many :tags, through: :work_tags
  
  has_many :notifications, dependent: :destroy
  
  has_one_attached :main_image
  has_many_attached :sub_images
  
  validates :title, presence: true
  validates :caption, presence: true
  
  # 表紙画像のサイズ調整
  def get_main_image(width, height)
    main_image.variant(resize: "#{width}x#{height}^", gravity: "center", crop: "#{width}x#{height}+0+0").processed
  end
  # userをいいねしているか
  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end
  
  def save_tags(tags)
    #既存のタグがあれば
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - tags
    new_tags = tags - current_tags
    #既存のタグを消す
    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name :old_name)
    end
    #新しいタグを消す
    new_tags.each do |new_name|
      tag = Tag.find_or_create_by(name: new_name)
      self.tags << tag
    end
  end
  
  #一週間にいいねが多い順に並び替え
  def self.sort_trend
    to  = Time.current.at_end_of_day
    from  = (to - 6.day).at_beginning_of_day
    all.sort_by{|x|x.likes.where(created_at: from...to).count}.reverse
  end
  
  def create_notification_like(current_user)
    #一度通知したものは通知しない
    unless Notification.where(visitor_id: current_user, visited_id: user_id, work_id: id, action: "like").present?
      @notification = current_user.notifications.new(
        visited_id: user_id,
        work_id: id,
        action: 0
        )
        #自分のいいねは通知しない
        unless @notification.visitor_id == @notification.visited_id
          @notification.save
        end
    end
  end
  
end
