class CreateOrganization < ActiveRecord::Migration[5.0]
  def change
    create_table :organizations do |t|
      t.uuid :uuid
      t.string :name
      t.timestamps
    end

    add_index :organizations, :uuid, unique: true

    Organization.all_names.each do |org_name|
      next if org_name == 'Other'
      Organization.find_or_create_by(name: org_name)
    end
  end
end
