# == Schema Information
#
# Table name: surveys
#
#  id              :integer          not null, primary key
#  uuid            :uuid
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Survey < ApplicationRecord
  belongs_to :organization
  has_many :questions
  has_many :survey_responses

  before_validation :ensure_uuid

  validates :organization, uniqueness: true

  def self.foster_roster
    joins(:organization).where(organizations: { uuid: Organization::FOSTER_DOGS_UUID })
  end

  def self.macc
    joins(:organization).where(organizations: { uuid: Organization::MACC_UUID })
  end

  private

  def ensure_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
