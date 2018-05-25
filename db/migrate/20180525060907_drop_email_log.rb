class DropEmailLog < ActiveRecord::Migration[5.0]
  def change
    drop_table :email_logs
  end
end
