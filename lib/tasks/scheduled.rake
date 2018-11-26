namespace :scheduled do
  desc 'caches csv of all users for export'
  task csv_export: :environment do
    Rails.logger.info("Caching User CSV for export!")
    csv = CsvService.users(users: User.all.order('created_at ASC'))
    Rails.cache.write('all-users-csv', csv, expires_in: 48.hours)
  end
end
