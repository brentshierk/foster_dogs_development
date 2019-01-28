require 'rails_helper'

describe SurveyResponsesController, type: :controller do
  describe '#create' do
    let(:email) { Faker::Internet.email }
    let(:survey) { FactoryBot.create(:survey) }
    let(:params) do
      {
        "first_name"=>Faker::Name.last_name,
        "last_name"=>Faker::Name.first_name,
        "email"=>email,
        "phone_number"=>Faker::PhoneNumber.phone_number,
        "date_of_birth"=>(Date.current - 20.years).stamp("1989-05-20"),
        "address"=>Faker::Address.full_address,
        "survey_uuid"=>survey.uuid,
        "survey"=>{ "foo"=>"bar" },
        "organization_slug" => survey.organization.slug,
        "accepted_terms_at"=>"true",
        "password"=>Faker::Internet.password
      }
    end

    it 'creates a user' do
      expect { post :create, params: params }.to change(User, :count).by(1)
    end

    it 'creates survey response' do
      expect { post :create, params: params }.to change(SurveyResponse, :count).by(1)
    end

    it 'sets all the correct user attributes' do
      post :create, params: params
      user = User.find_by(email: email)
      expect(user.first_name).to eq(params["first_name"])
      expect(user.last_name).to eq(params["last_name"])
      expect(user.email).to eq(params["email"])
      expect(user.phone_number).to eq(params["phone_number"])
      expect(user.date_of_birth).to eq(Date.parse(params["date_of_birth"]))
      expect(user.address).to eq(params["address"])
      expect(user.accepted_terms_at).to_not be_nil
    end

    it 'creates the survey response with correct info' do
      post :create, params: params
      user = User.find_by(email: email)
      response = user.survey_responses.first
      expect(response.survey).to eq(survey)
      expect(response.response).to eq({"foo"=>"bar"})
    end

    it 'redirects_to thank_you' do
      expect(post :create, params: params).to redirect_to(thanks_organization_survey_path(organization_slug: survey.organization.slug))
    end
  end
end
