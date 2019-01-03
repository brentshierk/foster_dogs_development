# == Schema Information
#
# Table name: surveys
#
#  id              :integer          not null, primary key
#  uuid            :uuid
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Survey < ApplicationRecord
  belongs_to :organization
  has_many :questions

  before_validation :ensure_uuid

  validates :organization, uniqueness: true

  private

  def ensure_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
