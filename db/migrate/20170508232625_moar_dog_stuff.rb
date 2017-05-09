class MoarDogStuff < ActiveRecord::Migration[5.0]
  def change
    remove_column :dogs, :uuid
    add_column :dogs, :birthday, :date
    add_index :dogs, :short_code, unique: true
  end
end
