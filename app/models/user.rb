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

class User < ApplicationRecord
  searchkick callbacks: :async

  paginates_per 50

  validates_uniqueness_of :uuid, :email
  validates_presence_of :name, :email, :uuid
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_validation :ensure_uuid

  has_many :notes
  has_many :survey_responses
  has_many :outreaches_users
  has_many :outreaches, through: :outreaches_users

  geocoded_by :address
  after_validation :geocode, if: ->(obj){ obj.address.present? && obj.address_changed? }
  after_commit :subscribe_to_mailchimp, on: :create

  scope :subscribed, -> { where.not(subscribed_at: nil).where(unsubscribed_at: nil) }

  def self.for_index_page
    subscribed
    .includes(outreaches: :organization)
    .order('created_at DESC')
  end

  def first_name
    name.split(' ', 2).first
  end

  def last_name
    name.split(' ', 2).last
  end

  def active?
    !subscribed_at.nil? && unsubscribed_at.nil?
  end

  private

  def ensure_uuid
    self.uuid ||= SecureRandom.uuid
  end

  def subscribe_to_mailchimp
    MailchimpWorker.perform_async(id) unless subscribed_at?
  end
end
