class AddDobToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :date_of_birth, :datetime
    add_column :users, :fostered_for, :text, array: true, default: []
  end
end
