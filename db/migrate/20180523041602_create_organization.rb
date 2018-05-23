class CreateOrganization < ActiveRecord::Migration[5.0]
  def change
    create_table :organizations do |t|
      t.uuid :uuid
      t.string :name
      t.timestamps
    end

    add_index :organizations, :uuid, unique: true

    organization_names.each { |org_name| Organization.find_or_create_by(name: org_name) }
  end

  def organization_names
    [
      'ACC',
      'Animal Lighthouse Rescue',
      'Badass Brooklyn',
      'BARRK',
      'Friends with Four Paws',
      'Hearts and Bones',
      'Heavenly Angels',
      'In Our Hands',
      'Long Road Home',
      'Louie\'s Legacy',
      'Muddy Paws',
      'PupStarz',
      'Sean Casey',
      'Shelter Chic',
      'Social Tees',
      'Sochi Dogs',
      'Sugar Mutts',
      'Twenty Paws',
      'Korean K9 Rescue',
      'True North Rescue Mission',
      'Mr. Bones & Co',
    ]
  end
end
