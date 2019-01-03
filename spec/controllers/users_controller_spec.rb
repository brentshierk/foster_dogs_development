require 'rails_helper'

describe UsersController, type: :controller do
  describe '#create' do
    let(:email) { Faker::Internet.email }
    let(:survey) { FactoryBot.create(:survey) }
    let(:params) do
      {
        "name"=>Faker::Name.name,
        "email"=>email,
        "phone_number"=>Faker::PhoneNumber.phone_number,
        "date_of_birth"=>(Date.current - 20.years).stamp("1989-05-20"),
        "address"=>Faker::Address.full_address,
        "survey"=>{
          "uuid"=>survey.uuid,
          "foo"=>"bar"
        },
        "accepted_terms_at"=>"true"
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
      expect(user.name).to eq(params["name"])
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
      expect(post :create, params: params).to redirect_to(thanks_users_path)
    end
  end

  describe '#create_old' do
    let(:email) { Faker::Internet.email }
    let(:params) do
      {
        "user"=> {
          "name"=>Faker::Name.name,
          "email"=>email,
          "date_of_birth(2i)"=>"5",
          "date_of_birth(3i)"=>"20",
          "date_of_birth(1i)"=>"1989",
          "address"=>Faker::Address.full_address,
          "fostered_before"=>"true",
          "fostered_for"=>[
            "Louie's Legacy",
            "Muddy Paws",
            "Mr. Bones & Co"
          ],
          "fospice"=>"true",
          "other_pets"=>"false",
          "kids"=>"false",
          "size_preferences"=>["Medium"],
          "experience"=>[
            "Dogsat",
            "Own / Owned a dog"
          ],
          "schedule"=>["Almost never (0-3 hrs/day)"],
          "activity_preferences"=>["Moderately active"],
          "big_dogs"=>"true",
          "fosters_cats"=>"true",
          "accepted_terms_at"=>"true"
        }
      }
    end

    context 'on success' do
      it 'creates a user' do
        expect { post :create_old, params: params }.to change(User, :count).by(1)
      end

      it 'creates user preferences' do
        post :create_old, params: params
        u = User.find_by(email: email)
        expect(u.size_preference_list.include?('Medium')).to be_truthy
        expect(u.experience_list.include?('Dogsat')).to be_truthy
        expect(u.experience_list.include?('Own / Owned a dog')).to be_truthy
        expect(u.schedule_list.include?('Almost never (0-3 hrs/day)')).to be_truthy
        expect(u.activity_preference_list.include?('Moderately active')).to be_truthy
      end
    end
  end
end
