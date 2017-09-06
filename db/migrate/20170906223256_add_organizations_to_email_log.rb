class AddOrganizationsToEmailLog < ActiveRecord::Migration[5.0]
  def change
    add_column :email_logs, :organization, :string
    add_index :email_logs, [:user_id, :organization]
  end
end
