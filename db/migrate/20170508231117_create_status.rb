class CreateStatus < ActiveRecord::Migration[5.0]
  def change
    create_table :statuses do |t|
      t.integer :user_id
      t.integer :dog_id
      t.string :status
      t.timestamps
    end

    add_index :statuses, :dog_id
    add_index :statuses, :user_id
  end
end
