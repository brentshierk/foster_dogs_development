class MailchimpService
  attr_accessor :api

  MASTER_LIST_ID = '934017' # foster roster master list

  def initialize
    @api = Mailchimp::API.new(ENV['MAILCHIMP_API_KEY'])
  end
end
