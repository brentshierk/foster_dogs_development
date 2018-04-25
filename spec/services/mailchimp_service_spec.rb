require 'rails_helper'

describe MailchimpService, type: :service do
  describe 'initialize' do
    it 'sets the API instance variable' do
      expect(MailchimpService.new.api.is_a?(Mailchimp::API)).to be_truthy
    end
  end
end
