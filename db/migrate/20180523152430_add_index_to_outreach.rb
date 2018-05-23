class AddIndexToOutreach < ActiveRecord::Migration[4.2]
  def change
    add_index :outreaches, :subject
  end
end
