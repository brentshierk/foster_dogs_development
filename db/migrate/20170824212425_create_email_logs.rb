class CreateEmailLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :email_logs do |t|
      t.integer :user_id
      t.string :subject
      t.timestamps
    end

    add_index :email_logs, :user_id
    add_index :email_logs, [:user_id, :subject]
  end
end
