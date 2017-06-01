# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  name              :string
#  email             :string
#  uuid              :uuid
#  experience        :string
#  schedule          :string
#  fospice           :boolean
#  accepted_terms_at :datetime
#  other_pets        :text
#  kids              :text
#  created_at        :datetime
#  updated_at        :datetime
#

class User < ActiveRecord::Base
  paginates_per 40

  validates_uniqueness_of :uuid, :email
  validates_presence_of :name, :email, :uuid

  before_validation :ensure_uuid

  has_many :notes, foreign_key: "user_id"

  private

  def ensure_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
