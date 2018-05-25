class ChangeDefaultCat < ActiveRecord::Migration[5.0]
  def change
    change_column_default :users, :fosters_cats, nil
  end
end
