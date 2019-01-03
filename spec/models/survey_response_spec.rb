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
end
