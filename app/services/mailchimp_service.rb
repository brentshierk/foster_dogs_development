class MailchimpService
  attr_accessor :api

  MASTER_LIST_ID = 'f82fbab61a' # foster roster master list

  def initialize
    @api = Mailchimp::API.new(ENV['MAILCHIMP_API_KEY'])
  end

  def list_members
    api.lists.members(MASTER_LIST_ID)['data']
  end

  def subscribe_user(user)
    api.lists.subscribe(
      MASTER_LIST_ID,
      { email: user.email }
    )
  end
end
