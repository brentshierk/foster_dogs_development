class ExtraUserStuff < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :line_one
      t.string :line_two
      t.string :city
      t.string :zip
      t.string :city
      t.decimal :latitude
      t.decimal :longitude
      t.integer :user_id
      t.timestamps
    end

    add_column :users, :experience, :string
    add_column :users, :schedule, :string
    add_column :users, :fospice, :boolean
    add_column :users, :accepted_terms_at, :datetime
    add_column :users, :other_pets, :text
    add_column :users, :kids, :text
    add_column :users, :created_at, :datetime
    add_column :users, :updated_at, :datetime

    create_table :notes do |t|
      t.integer :user_id
      t.integer :author_id
      t.text :note
      t.timestamps
    end

    add_index :notes, [:user_id, :author_id]
  end
end
