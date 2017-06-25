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

    add_column :users, :fostered_before, :boolean
    add_column :users, :fospice, :boolean
    add_column :users, :accepted_terms_at, :datetime
    add_column :users, :other_pets, :boolean
    add_column :users, :kids, :boolean
  end
end
