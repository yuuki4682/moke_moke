class Notification < ApplicationRecord
  
  belongs_to :visitor, class_name: "User"
  belongs_to :visited, class_name: "User"
  belongs_to :work, optional: true
  belongs_to :chat, optional: true
  belongs_to :comment, optional: true
  
  enum action: { like: 0, chat: 1, comment: 2, follow: 3 }
  
end
