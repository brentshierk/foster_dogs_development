# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

100.times do
  dog = FactoryGirl.create(:dog)
  statuses = [:foster_pending, :in_foster, :adoption_pending, :adopted]

  rand(5).times do
    FactoryGirl.create(:status, statuses[rand(statuses.length)], dog: dog)
  end
end