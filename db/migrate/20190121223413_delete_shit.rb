class DeleteShit < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :fostered_before
    remove_column :users, :fospice
    remove_column :users, :other_pets
    remove_column :users, :kids
    remove_column :users, :fostered_for
    remove_column :users, :fosters_cats
    remove_column :users, :big_dogs

    drop_table :tags
    drop_table :taggings
  end
end
