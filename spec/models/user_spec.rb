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
#  first_name        :string
#  last_name         :string
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

  # no one ever seems to make up their mind about full name vs. first/last
  # code to keep both for now
  describe '#ensure_name' do
    it 'sets name based off of first name' do
      expect(subject.name).to be_nil
      subject.valid?
      expect(subject.name).to_not be_nil
    end
  end
end
