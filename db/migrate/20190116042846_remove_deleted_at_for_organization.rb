class RemoveDeletedAtForOrganization < ActiveRecord::Migration[5.0]
  def change
    remove_column :organizations, :deleted_at, :datetime
  end
end
