class CreateDog < ActiveRecord::Migration[5.0]
  def change
    create_table :dogs do |t|
      t.string :name
      t.uuid :uuid
      t.text :short_code
      t.text :image_url
      t.datetime :archived_at
      t.timestamps
    end
  end
end
