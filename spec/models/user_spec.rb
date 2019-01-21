# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  name              :string
#  email             :string
#  uuid              :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  accepted_terms_at :datetime
#  address           :string
#  latitude          :float
#  longitude         :float
#  date_of_birth     :datetime
#  subscribed_at     :datetime
#  unsubscribed_at   :datetime
#  phone_number      :string
#

require 'rails_helper'

describe User, type: :model do
  subject { FactoryBot.build(:user) }

  context 'callbacks' do
    it 'calls subscribe_to_mailchimp' do
      expect(subject).to receive(:subscribe_to_mailchimp)
      subject.save!
    end
  end

  describe '#subscribe_to_mailchimp' do
    it 'subscribes to mailchimp' do
      expect(MailchimpWorker).to receive(:perform_async)
      subject.save!
    end
  end
end
