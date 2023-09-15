class AddDetailsToReports < ActiveRecord::Migration[6.1]
  def change
    add_column :reports, :work_id, :integer
    add_column :reports, :comment_id, :integer
    add_column :reports, :chat_id, :integer
  end
end
