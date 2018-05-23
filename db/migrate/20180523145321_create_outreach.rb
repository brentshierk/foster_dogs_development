class CreateOutreach < ActiveRecord::Migration[5.2]
  def change
    create_table :outreaches do |t|
      t.uuid :uuid
      t.text :subject
      t.integer :organization_id
      t.timestamps
    end

    add_index :outreaches, :uuid, unique: :true

    create_join_table :outreaches, :users
  end
end
