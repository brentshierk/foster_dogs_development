class AddBigDogsToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :big_dogs, :boolean
  end
end
