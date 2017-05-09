FactoryGirl.define do
  factory :dog do
    name { Faker::Name.first_name }  
    image_url { Faker::LoremPixel.image }
    birthday { Date.current - rand(10).years - rand(3).months }

    trait :urgent do
      urgent true
    end
  end

  factory :status do
    dog
    user

    trait :needs_foster do
      status Status::NEEDS_FOSTER
    end

    trait :foster_pending do
      status Status::FOSTER_PENDING
    end
    
    trait :in_foster do
      status Status::IN_FOSTER
    end

    trait :adoption_pending do
      status Status::ADOPTION_PENDING
    end
  end

  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
  end
end