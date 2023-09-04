class CreateWorkTags < ActiveRecord::Migration[6.1]
  def change
    create_table :work_tags do |t|
      t.integer :work_id, null: false
      t.integer :tag_id, null: false

      t.timestamps
    end
  end
end
