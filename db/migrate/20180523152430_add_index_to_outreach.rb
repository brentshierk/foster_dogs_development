class AddIndexToOutreach < ActiveRecord::Migration[5.2]
  def change
    add_index :outreaches, :subject
  end
end
