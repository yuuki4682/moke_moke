class Tag < ApplicationRecord
  
  has_many :work_tags, dependent: :destroy
  has_many :works, through: :work_tags
  
  validates :name, presence: true, length: {maximum:10}
  
  def self.search(word)
    self.where("name LIKE?", "%#{word}%")
  end 
  
  def self.top(num)
    all.sort_by{|tag|tag.works.count}.reverse.first(num)
  end
  
end
