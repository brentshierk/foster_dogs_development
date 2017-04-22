FactoryGirl.define do
  factory :dog do
    name { Faker::Name.first_name }  
    image_url { Faker::LoremPixel.image }
  end
end