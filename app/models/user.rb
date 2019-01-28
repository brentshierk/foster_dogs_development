# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string
#  email                  :string
#  uuid                   :uuid
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  accepted_terms_at      :datetime
#  address                :string
#  latitude               :float
#  longitude              :float
#  date_of_birth          :datetime
#  subscribed_at          :datetime
#  unsubscribed_at        :datetime
#  phone_number           :string
#  first_name             :string
#  last_name              :string
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#

class User < ApplicationRecord
  rolify

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  searchkick callbacks: :async

  paginates_per 50

  validates_uniqueness_of :uuid, :email
  validates_presence_of :first_name, :name, :email, :uuid
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_validation :ensure_uuid, :ensure_name

  has_many :notes, dependent: :destroy
  has_many :survey_responses, dependent: :destroy
  has_many :outreaches_users
  has_many :outreaches, -> { order("created_at DESC") }, through: :outreaches_users

  geocoded_by :address
  after_validation :geocode, if: ->(obj){ obj.address.present? && obj.address_changed? }
  after_commit :subscribe_to_mailchimp, on: :create

  scope :subscribed, -> { where.not(subscribed_at: nil).where(unsubscribed_at: nil) }

  def self.for_index_page
    subscribed
    .includes(outreaches: :organization)
    .order('created_at DESC')
  end

  def active?
    !subscribed_at.nil? && unsubscribed_at.nil?
  end

  private

  def ensure_name
    self.name ||= "#{first_name} #{last_name}"
  end

  def ensure_uuid
    self.uuid ||= SecureRandom.uuid
  end

  def subscribe_to_mailchimp
    MailchimpWorker.perform_async(id) unless subscribed_at?
  end
end
