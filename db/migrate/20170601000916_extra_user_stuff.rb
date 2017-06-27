class ExtraUserStuff < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :fostered_before, :boolean
    add_column :users, :fospice, :boolean
    add_column :users, :accepted_terms_at, :datetime
    add_column :users, :other_pets, :boolean
    add_column :users, :kids, :boolean
    add_column :users, :address, :string
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
  end
end
