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
#  date_of_birth     :datetime
#  fostered_for      :text             default([]), is an Array
#

class User < ActiveRecord::Base
  searchkick

  paginates_per 40

  validates_uniqueness_of :uuid, :email
  validates_presence_of :name, :email, :uuid

  before_validation :ensure_uuid

  has_many :email_logs
  has_many :notes

  acts_as_taggable
  acts_as_taggable_on :experience, :schedule, :size_preferences, :activity_preferences

  # geocoded_by :address
  # after_validation :geocode, if: ->(obj){ obj.address.present? && obj.address_changed? }

  # TODO: maybe refactor this
  SIZE_PREFERENCES = {
    "Small" => "Up to 25 lbs.",
    "Medium" => "25-50 lbs.",
    "Large" => "50 lbs and up"
  }
  EXPERIENCE = ["Dogsat", "Fostered", "Own / Owned a dog", "Volunteered", "Other"]
  SCHEDULE = ["Almost never (0-3 hrs/day)", "4-7 hours per day", "8+ hours per day"]
  ACTIVITY_PREFERENCES = ["Low activity", "Moderately active", "Active", "Young puppy"]

  def to_indexed_json
    {
      uuid: uuid,
      name: name,
      email: email,
      fostered_before: fostered_before,
      fospice: fospice,
      other_pets: other_pets,
      kids: kids,
      address: address
    }.to_json
  end

  def self.size_preferences
    tag_counts_on("size_preferences").map(&:name).uniq.sort
  end

  private

  def ensure_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
