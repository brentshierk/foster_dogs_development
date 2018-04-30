class AddCatsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :fosters_cats, :boolean, default: false
  end
end
