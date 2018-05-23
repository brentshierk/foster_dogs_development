namespace :outreach do
  desc 'migrates from email_log to outreach'
  task migrate_email_log: :environment do
    EmailLog.find_each do |el|
      user = el.user

      outreach = Outreach.find_or_create_by(subject: el.subject) do |outreach|
        outreach.created_at = el.created_at
        outreach.updated_at = el.updated_at
        outreach.organization = Organization.find_by(name: el.organization)
      end

      outreach.users << el.user unless outreach.users.include?(user)
    end
  end
end
