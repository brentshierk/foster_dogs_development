# == Schema Information
#
# Table name: dogs
#
#  id          :integer          not null, primary key
#  name        :string
#  uuid        :uuid
#  short_code  :text
#  image_url   :text
#  archived_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Dog < ActiveRecord::Base
  paginates_per 40
  
  before_save :ensure_uuid, :ensure_short_code

  private

  def ensure_uuid
    self.uuid ||= SecureRandom.uuid
  end

  def ensure_short_code
    self.short_code ||= SecureRandom.hex(3)
  end
end
