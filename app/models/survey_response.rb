# == Schema Information
#
# Table name: survey_responses
#
#  id              :integer          not null, primary key
#  uuid            :uuid             not null
#  user_id         :integer          not null
#  survey_id       :integer          not null
#  organization_id :integer          not null
#  response        :jsonb            not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class SurveyResponse < ApplicationRecord
  belongs_to :user
  belongs_to :organization
  belongs_to :survey

  validates_presence_of :user, :survey, :organization, :response
  validates_uniqueness_of :user_id, scope: [:survey_id, :organization_id]
  before_validation :ensure_uuid, :ensure_organization

  def self.foster_roster
    joins(:organization).where(organizations: { uuid: Organization::FOSTER_DOGS_UUID })
  end

  def self.macc
    joins(:organization).where(organizations: { uuid: Organization::MACC_UUID })
  end

  private

  def ensure_organization
    self.organization = survey.organization
  end

  def ensure_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
