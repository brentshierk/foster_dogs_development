namespace :scheduled do
  desc 'caches csv of all users for export'
  task csv_export: :environment do
    Rails.cache.fetch('all-users-csv', expires_in: 48.hours) do
      CsvService.users(users: User.all.order('created_at ASC'))
    end
  end
end
