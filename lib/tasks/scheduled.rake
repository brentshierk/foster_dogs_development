namespace :scheduled do
  desc 'caches csv of all users for export'
  task csv_export: :environment do
    Rails.logger.info("Caching User CSV for export!")
    Rails.cache.write('all-users-csv', expires_in: 48.hours) do
      CsvService.users(users: User.all.order('created_at ASC'))
    end
  end
end
