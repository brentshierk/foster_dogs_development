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

  before_validation :ensure_uuid, :ensure_organization

  private

  def ensure_organization
    self.organization = survey.organization
  end

  def ensure_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
