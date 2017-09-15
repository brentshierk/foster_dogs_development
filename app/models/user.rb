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
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  
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

  private

  def ensure_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
