class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :works, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  has_many :likes, dependent: :destroy
  has_many :like_works, through: :likes, source: :work
  
  has_one_attached :profile_image
  
  GUEST_USER_EMAIL = "guest@example.com"
  
  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end
  
  def upload_default_profile_image
    file_path = Rails.root.join("app/assets/images/no_image.jpg")
    profile_image.attach(io: File.open(file_path), filename: "default-image.jpg", content_type: "image/jpeg")
  end
  
  def get_profile_image(width, height)
    upload_default_profile_image unless profile_image.attached?
    profile_image.variant(resize: "#{width}x#{height}^", gravity: "center", crop: "#{width}x#{height}+0+0").processed
  end
  
end
