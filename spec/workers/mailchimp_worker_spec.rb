require 'rails_helper'

describe MailchimpWorker, type: :worker do
  let(:user) { FactoryBot.create(:user) }
  let(:mailchimp_service) { double(MailchimpService) }

  describe '#perform' do
    before do
      allow(user).to receive(:subscribe_to_mailchimp)
      allow(MailchimpService).to receive(:new) { mailchimp_service }
      expect(user.subscribed_at).to be_nil
    end

    it 'attempts to subscribe user' do
      expect(mailchimp_service).to receive(:subscribe_user).with(user)
      described_class.new.perform(user.id)
    end

    it 'sets the subscribed_at' do
      allow(mailchimp_service).to receive(:subscribe_user).with(user)
      described_class.new.perform(user.id)
      expect(user.reload.subscribed_at).to_not be_nil
    end

    context 'user already subscribed manually' do
      before do
        allow(mailchimp_service).to receive(:subscribe_user).and_raise(Mailchimp::ListAlreadySubscribedError)
      end

      it 'sets the subscribed_at' do
        allow(mailchimp_service).to receive(:subscribe_user).with(user)
        described_class.new.perform(user.id)
        expect(user.reload.subscribed_at).to_not be_nil
      end
    end
  end
end
