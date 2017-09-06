class CreateNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :notes do |t|
      t.integer :user_id
      t.text :note
      t.string :author
      t.timestamps
    end
  end
end
