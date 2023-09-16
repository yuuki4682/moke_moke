class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :works, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  has_many :likes, dependent: :destroy
  has_many :like_works, through: :likes, source: :work
  
  #DM機能
  has_many :chats, dependent: :destroy
  has_many :user_rooms, dependent: :destroy
  has_many :rooms, through: :user_rooms
 
 #与フォローの関係
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed
  #被フォローの関係
  has_many :reverse_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  
  #通知機能
  has_many :notifications, class_name: "Notification", foreign_key: "visitor_id", dependent: :destroy
  has_many :reverse_notifications, class_name: "Notification", foreign_key: "visited_id", dependent: :destroy
  
  #通報機能
  has_many :reports, class_name: "Report", foreign_key: "reporter_id", dependent: :destroy
  has_many :reverse_reports, class_name: "Report", foreign_key: "reported_id", dependent: :destroy
  
  has_one_attached :profile_image
  
  GUEST_USER_EMAIL = "guest@example.com"
  
  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end
  #デフォルト画像の設定
  def upload_default_profile_image
    file_path = Rails.root.join("app/assets/images/no_image.jpg")
    profile_image.attach(io: File.open(file_path), filename: "default-image.jpg", content_type: "image/jpeg")
  end
  
  def get_profile_image(width, height)
    upload_default_profile_image unless profile_image.attached?
    profile_image.variant(resize: "#{width}x#{height}^", gravity: "center", crop: "#{width}x#{height}+0+0").processed
  end
  
  def follow(user)
    relationships.create(followed_id: user.id)
  end
  
  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end
  
  def following?(user)
    followings.include?(user)
  end
  
  def create_notification_follow(current_user)
    #一度通知したものは通知しない
    unless Notification.where(visitor_id: current_user, visited_id: id, action: "follow").present?
      @notification = current_user.notifications.new(
        visited_id: id,
        action: 3
        )
      @notification.save
    end
  end
  
  def have_unread_notification?
    notifications = Notification.where(visited_id: id)
    notifications.find_by(checked: false).present?
  end
  
  def self.search(word)
    self.where("name LIKE?", "%#{word}%")
  end 
  
end
