class Work < ApplicationRecord
  
  belongs_to :user
  
  has_one_attached :main_image
  has_many_attached :sub_images
  
  
end
