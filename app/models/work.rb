class Work < ApplicationRecord
  
  belongs_to :user
  
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  has_many :work_tags, dependent: :destroy
  has_many :tags, through: :work_tags
  
  has_one_attached :main_image
  has_many_attached :sub_images
  
  validates :title, presence: true
  validates :caption, presence: true
  
  # 表紙画像のサイズ調整
  def get_main_image(width, height)
    main_image.variant(resize: "#{width}x#{height}^", gravity: "center", crop: "#{width}x#{height}+0+0").processed
  end
  # いいねしているか
  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end
  
  def save_tags(tags)
    #既存のタグがあれば
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - tags
    new_tags = tags - current_tags
    
    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name :old_name)
    end
    
    new_tags.each do |new_name|
      tag = Tag.find_or_create_by(name: new_name)
      self.tags << tag
    end
  end
  
  def self.sort_trend
    to  = Time.current.at_end_of_day
    from  = (to - 6.day).at_beginning_of_day
    all.sort_by{|x|x.likes.where(created_at: from...to).count}.reverse
  end
  
end
