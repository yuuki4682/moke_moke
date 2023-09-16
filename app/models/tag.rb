class Tag < ApplicationRecord
  
  has_many :work_tags, dependent: :destroy
  has_many :works, through: :work_tags
  
  validates :name, presence: true, length: {maximum:50}
  
  def self.search(word)
    self.where("name LIKE?", "%#{word}%")
  end 
  
end
