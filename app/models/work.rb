class Work < ApplicationRecord
  
  belongs_to :user
  
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :view_counts, dependent: :destroy
  
  has_many :work_tags, dependent: :destroy
  has_many :tags, through: :work_tags
  
  has_many :notifications, dependent: :destroy
  has_many :reports, dependent: :destroy
  
  has_one_attached :main_image
  has_many_attached :sub_images
  
  validates :title, presence: true, length: { maximum: 20 }
  validates :caption, presence: true, length: { maximum: 200 } 
  validates :main_image, presence: true
  validates :sub_images, presence: true
  
  
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
      self.tags.delete Tag.find_by(name: old_name)
    end
    #新しいタグを消す
    new_tags.each do |new_name|
      tag = Tag.find_or_create_by(name: new_name)
      self.tags << tag
    end
  end
  
  #一週間にいいねが多い順に並び替え
  
  has_many :week_likes, ->{ where(created_at: (Time.current.at_end_of_day - 6.day).at_beginning_of_day...Time.current.at_end_of_day)}, class_name: "Like"
  has_many :week_view_counts, ->{ where(created_at: (Time.current.at_end_of_day - 6.day).at_beginning_of_day...Time.current.at_end_of_day)}, class_name: "ViewCount"
  
  def self.sort(option)
    if option == "like"
      left_joins(:week_likes).group(:id).order("count(likes.work_id) desc")
    elsif option == "pv"
      left_joins(:week_view_counts).group(:id).order("count(view_counts.work_id) desc")
    end
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
  
  def reported_by?(current_user)
    reports.find_by(reporter_id: current_user.id).present?
  end
  
  def self.search(word)
    self.where("title LIKE?", "%#{word}%")
  end
  
  def add_view_count(current_user)
    unless view_counts.where(user_id: current_user.id, work_id: id).present?
      view_counts.create(user_id: current_user.id)
    end
  end
  
end
