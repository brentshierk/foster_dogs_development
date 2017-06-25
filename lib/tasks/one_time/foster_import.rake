require 'csv'

namespace :one_time do
  namespace :fosters do
    desc "imports fosters into database"
    task import: :environment do
      CSV.foreach("data/roster.csv") do |row|
        begin
          timestamp = row[0]
          first_name = row[1]
          last_name = row[2]
        rescue => e

        end
      end
    end
  end
end

# 2017 (Q2)
# Chris
# Soper
# chrisrsoper@gmail.com
# 21-35
# NYC: Brooklyn
# Greenpoint
# 154 Freeman St Apt 3R, Brooklyn, NY 11222
# Small (Up to 25 lbs), Medium (25 - 50 lbs), Large (50+ lbs)
# Young Puppy (not yet housetrained, chews, stays indoors versus outside walks due to limited vaccinations), Active: Frisky, playful, energetic, jogging buddy, Moderately active: Enjoys walks and chilling, with occasional playtime, Low activity: Couch potato / senior dog.
# Own / Owned a dog
#
# I recently had two dogs move out of my home when a significant other moved out and have plenty of room to love a pup! My current situation is not ideal for the long term commitment of adopting, but if I can foster and help socialize a dog to give them a better chance of adoption success, I think it will be a win-win. The two dogs that I helped care for the past 4 years were large, pit-mix rescues from the ACC in Harlem.
# No other pets
# No
# 4-7 hours per day
# I am a record producer and work out of my own studio. Many days I work alone, in which case I would bring a dog to work with me.
# One roomate, who is happy to have a dog in the house.
# No / Not Now
# Google search
# I understand and accept
