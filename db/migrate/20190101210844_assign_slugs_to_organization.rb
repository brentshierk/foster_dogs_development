class AssignSlugsToOrganization < ActiveRecord::Migration[5.0]
  def change
    Organization.find_each { |o| o.save! }
    change_column :organizations, :slug, :string, null: false
  end
end
