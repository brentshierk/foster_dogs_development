# == Schema Information
#
# Table name: organizations
#
#  id           :integer          not null, primary key
#  uuid         :uuid
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  deleted_at   :datetime
#  published_at :datetime
#  slug         :string           not null
#

class Organization < ApplicationRecord
  acts_as_paranoid

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :outreaches
  has_one :survey

  before_validation :ensure_uuid, :ensure_slug

  # used to list out names for the organization checkboxes on onboarding
  # could be moved to application helper
  def self.all_names
    pluck(:name).append('Other')
  end

  private

  def ensure_uuid
    self.uuid ||= SecureRandom.uuid
  end

  def ensure_slug
    self.slug ||= name.parameterize.underscore
  end
end
