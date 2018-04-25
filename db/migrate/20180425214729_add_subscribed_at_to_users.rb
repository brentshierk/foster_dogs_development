class AddSubscribedAtToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :subscribed_at, :datetime
    add_column :users, :unsubscribed_at, :datetime
  end
end
