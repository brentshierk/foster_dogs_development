FactoryBot.define do

  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
  end

  factory :organization do
    name { Faker::Company.name }
  end

  factory :survey do
  end

  factory :survey_with_questions do
    organization

    after :create do |svy|
      rand(10).times { create(:question, survey: svy) }
    end
  end

  factory :question do
    slug { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
    question_text { Faker::Lorem.paragraph }
    question_type { Question::FORMATS.sample }
    question_subtext { Faker::Lorem.paragraph }
    survey

    before :save do |q|
      q.question_choices = ['foo', 'bar'] if q.multiple_answer?
    end
  end

  factory :survey_response do
    user
    organization
    survey
    response { {foo: 'bar'} }
  end

  factory :dog do
    name { Faker::Name.first_name }
    image_url { Faker::LoremPixel.image }
    birthday { Date.current - rand(10).years - rand(3).months }
    breed { ['Doggo', 'Pupperino', 'Bork'][rand(3)] }
    weight { rand(100) }

    trait :urgent do
      urgent true
    end
  end

  factory :status do
    dog

    trait :needs_foster do
      status Status::NEEDS_FOSTER
    end

    trait :foster_pending do
      status Status::FOSTER_PENDING
      user
    end

    trait :in_foster do
      status Status::IN_FOSTER
      user
    end

    trait :adoption_pending do
      status Status::ADOPTION_PENDING
      user
    end

    trait :adopted do
      status Status::ADOPTED
      user
    end
  end
end
