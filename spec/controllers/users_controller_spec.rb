require 'rails_helper'

describe UsersController, type: :controller do
  describe '#create' do
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
        expect { post :create, params: params }.to change(User, :count).by(1)
      end

      it 'creates user preferences' do
        post :create, params: params
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
