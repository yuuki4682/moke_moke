class Report < ApplicationRecord
  
  belongs_to :reporter, class_name: "User"
  belongs_to :reported, class_name: "User"
  belongs_to :work, optional: true
  belongs_to :chat, optional: true
  belongs_to :comment, optional: true
  
  enum reason: { improper_work_post: 0, improper_chat: 1, improper_comment: 2 }
  
end
