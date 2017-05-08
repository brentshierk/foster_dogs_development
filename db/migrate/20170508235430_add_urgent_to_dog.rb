class AddUrgentToDog < ActiveRecord::Migration[5.0]
  def change
    add_column :dogs, :urgent, :boolean, default: false
  end
end
