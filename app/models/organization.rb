# == Schema Information
#
# Table name: organizations
#
#  id         :integer          not null, primary key
#  uuid       :uuid
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Organization < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name

  before_validation :ensure_uuid

  def self.all_names
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
      'Other'
    ]
  end

  private

  def ensure_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
