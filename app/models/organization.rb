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

  # used to list out names for the organization checkboxes on onboarding
  # could be moved to application helper
  def self.all_names
    pluck(:name).append('Other')
  end

  private

  def ensure_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
