namespace :one_time do
  namespace :users do
    desc 'backfills first/last name'
    task backfill_names: :environment do
      User.find_each do |user|
        name = user.name.split(' ', 2)
        user.update_columns(first_name: name.first, last_name: name.last)
      end
    end
  end
end
