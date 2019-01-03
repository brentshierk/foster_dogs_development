class AddPrimaryKeytoOutreachesUser < ActiveRecord::Migration[5.0]
  def change
    add_column :outreaches_users, :id, :primary_key
  end
end
