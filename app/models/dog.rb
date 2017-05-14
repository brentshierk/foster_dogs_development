# == Schema Information
#
# Table name: dogs
#
#  id          :integer          not null, primary key
#  name        :string
#  short_code  :text
#  image_url   :text
#  archived_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  birthday    :date
#  urgent      :boolean          default(FALSE)
#  breed       :string
#  weight      :integer
#

class Dog < ActiveRecord::Base
  paginates_per 40
  
  before_validation :ensure_short_code

  validates_uniqueness_of :short_code
  validates_presence_of :short_code, :name, :birthday, :breed, :weight

  has_many :statuses
  has_one :current_status, -> { order('statuses.created_at') }, class_name: 'Status'

  default_scope { includes(current_status: :user) }

  def current_user
    current_status.user
  end

  private

  def ensure_short_code
    self.short_code ||= SecureRandom.hex(3).upcase
  end
end
