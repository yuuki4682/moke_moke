class Comment < ApplicationRecord
    
  belongs_to :user
  belongs_to :work
  
  validates :message, presence: true
  
end
