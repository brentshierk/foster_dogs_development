require 'rails_helper'

describe SurveysController, type: :controller do
  describe '#show' do
    let!(:survey) { FactoryBot.create(:survey, :with_questions) }
    let!(:organization) { survey.organization }

    it 'loads the organization' do
      get :show, params: { organization_slug: organization.slug }
      expect(assigns(:organization)).to eq(organization)
      expect(assigns(:survey)).to eq(survey)
    end
  end
end
