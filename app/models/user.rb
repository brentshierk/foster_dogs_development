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
#  fostered_before   :boolean
#  fospice           :boolean
#  accepted_terms_at :datetime
#  other_pets        :boolean
#  kids              :boolean
#  address           :string
#  latitude          :float
#  longitude         :float
#

class User < ActiveRecord::Base
  paginates_per 40

  validates_uniqueness_of :uuid, :email
  validates_presence_of :name, :email, :uuid

  before_validation :ensure_uuid

  has_many :email_logs
  has_many :notes

  acts_as_taggable
  acts_as_taggable_on :experience, :schedule, :size_preferences, :activity_preferences

  geocoded_by :address
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }

  private

  def ensure_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
