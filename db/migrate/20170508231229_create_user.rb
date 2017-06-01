class CreateUser < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.uuid :uuid
      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :uuid, unique: true
  end
end
