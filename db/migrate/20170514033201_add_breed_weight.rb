class AddBreedWeight < ActiveRecord::Migration[5.0]
  def change
    add_column :dogs, :breed, :string
    add_column :dogs, :weight, :integer
  end
end
