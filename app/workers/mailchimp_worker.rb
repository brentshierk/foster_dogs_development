class MailchimpWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    MailchimpService.new.subscribe_user(user)
  rescue Mailchimp::ListAlreadySubscribedError => e
    Rails.logger.info("User already subscribed to Mailchimp!")
  ensure
    user.update_attributes!(subscribed_at: DateTime.current) unless user.subscribed_at?
  end
end
