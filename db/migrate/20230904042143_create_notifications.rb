class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :visitor_id, null: false
      t.integer :visited_id, null: false
      t.integer :chat_id
      t.integer :work_id
      t.integer :comment_id
      t.integer :action
      t.boolean :checked, default: false

      t.timestamps
    end
  end
end
