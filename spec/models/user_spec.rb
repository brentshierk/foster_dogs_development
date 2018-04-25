require 'rails_helper'

describe User, type: :model do
  subject { FactoryGirl.build(:user) }

  context 'callbacks' do
    it 'calls subscribe_to_mailchimp' do
      expect(subject).to receive(:subscribe_to_mailchimp)
      subject.save!
    end
  end

  describe '#subscribe_to_mailchimp' do
    let(:mailchimp) { double(MailchimpService) }

    it 'subscribes to mailchimp' do
      expect(MailchimpService).to receive(:new) { mailchimp }
      expect(mailchimp).to receive(:subscribe_user).with(subject)
      subject.save!
    end

    it 'marks the user as subscribed' do
      allow(MailchimpService).to receive(:new) { mailchimp }
      allow(mailchimp).to receive(:subscribe_user).with(subject)
      subject.save!
      expect(subject.reload.subscribed_at).to_not be_nil
    end
  end
end
