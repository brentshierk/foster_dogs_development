# == Schema Information
#
# Table name: outreaches
#
#  id              :bigint(8)        not null, primary key
#  uuid            :uuid
#  subject         :text
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Outreach < ApplicationRecord
  before_create :ensure_uuid

  belongs_to :organization
  has_many :outreaches_users, dependent: :destroy
  has_many :users, through: :outreaches_users

  private

  def ensure_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
