namespace :one_time do
  namespace :users do
    desc 'backfills first/last name'
    task backfill_names: :environment do
      User.find_each do |user|
        name = user.name.split(' ', 2)
        user.update_columns(first_name: name.first, last_name: name.last)
      end
    end

    desc 'seeds two admin accounts'
    task seed_admins: :environment do
      password = 'shaggyozzie123'

      seeded_users = [
        {
          email: 'nancy@fosterdogsnyc.com',
          first_name: 'Nancy',
          last_name: 'Noto',
          password: password,
        },
        {
          email: 'sarah@fosterdogsnyc.com',
          first_name: 'Sarah',
          last_name: 'Brasky',
          password: password,
        },
        {
          email: 'elana@fosterdogsnyc.com',
          first_name: 'Elana',
          last_name: 'Buchalter',
          password: password,
        },
        {
          email: 'kevin@fosterdogsnyc.com',
          first_name: 'Kevin',
          last_name: 'Hsieh',
          password: 'shaggyozzie123',
        },
        {
          email: 'taylor@fosterdogsnyc.com',
          first_name: 'Taylor',
          last_name: 'Solomon',
          password: 'macc123',
        }
      ]

      seeded_users.each do |user_info|
        ActiveRecord::Base.transaction do
          user = User.find_or_initialize_by(email: user_info[:email])
          user.attributes = user_info
          user.save!
          organization =  if user.email == 'taylor@fosterdogsnyc.com'
                            Organization.macc
                          else
                            Organization.foster_dogs
                          end

          user.add_role(:admin, organization)
        end
      end
    end
  end
end
