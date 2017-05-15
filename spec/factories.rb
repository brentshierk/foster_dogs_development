FactoryGirl.define do
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

  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
  end
end