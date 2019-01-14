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

require 'rails_helper'

describe SurveyResponse, type: :model do
  it 'has a user' do
    expect(subject).to respond_to(:user)
  end

  it 'has an organization' do
    expect(subject).to respond_to(:organization)
  end

  it 'has an survey' do
    expect(subject).to respond_to(:survey)
  end

  describe '.foster_roster' do
    let!(:organization) { FactoryBot.create(:organization, :foster_roster) }
    let!(:survey) { FactoryBot.create(:survey, organization: organization) }
    let!(:response) { FactoryBot.create(:survey_response, organization: organization, survey: survey) }

    it 'returns the survey responses of those that sent a survey through foster roster' do
      expect(SurveyResponse.foster_roster).to include(response)
    end
  end

  describe '.macc' do
    let!(:organization) { FactoryBot.create(:organization, :macc) }
    let!(:survey) { FactoryBot.create(:survey, organization: organization) }
    let!(:response) { FactoryBot.create(:survey_response, organization: organization, survey: survey) }

    it 'returns the survey responses of those that sent a survey through MACC' do
      expect(SurveyResponse.macc).to include(response)
    end
  end
end
