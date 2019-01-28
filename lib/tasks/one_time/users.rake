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
          email: 'elsie@fosterdogsnyc.com',
          first_name: 'Elsie',
          last_name: 'Hueng',
          password: password,
        }
      ]

      seeded_users.each do |user_info|
        ActiveRecord::Base.transaction do
          user = User.find_or_initialize_by(email: user_info[:email])
          user.attributes = user_info
          user.save!
          user.add_role(:admin, organization)
        end
      end
    end
  end
end
