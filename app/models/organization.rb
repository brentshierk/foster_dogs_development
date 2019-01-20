# == Schema Information
#
# Table name: organizations
#
#  id           :integer          not null, primary key
#  uuid         :uuid
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  published_at :datetime
#  slug         :string           not null
#

class Organization < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :outreaches
  has_one :survey
  has_many :survey_responses, through: :survey
  has_many :users, through: :survey_responses

  before_validation :ensure_uuid, :ensure_slug

  FOSTER_DOGS_UUID = 'ad9dacb7-f6f5-4874-8051-76f00f65d2ff'
  MACC_UUID= '2df431c8-f57d-4480-8249-f149fab7be58'

  # used to list out names for the organization checkboxes on onboarding
  # could be moved to application helper
  def self.all_names
    pluck(:name).append('Other')
  end

  def self.foster_dogs
    find_by(uuid: FOSTER_DOGS_UUID)
  end

  def self.macc
    find_by(uuid: MACC_UUID)
  end

  private

  def ensure_uuid
    self.uuid ||= SecureRandom.uuid
  end

  def ensure_slug
    self.slug ||= name.parameterize
  end
end
