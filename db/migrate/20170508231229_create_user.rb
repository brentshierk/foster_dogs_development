class CreateUser < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.uuid :uuid
    end

    add_index :users, :email
    add_index :users, :uuid
  end
end
