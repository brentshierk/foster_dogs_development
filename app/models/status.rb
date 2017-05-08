# == Schema Information
#
# Table name: statuses
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  dog_id     :integer
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Status < ActiveRecord::Base
  NEEDS_FOSTER = 'Needs Foster'
  FOSTER_PENDING = 'Foster Pending'
  IN_FOSTER = 'In Foster'
  ADOPTION_PENDING = 'Adoption Pending'
  ADOPTED = 'Adopted'

  STATUSES = [NEEDS_FOSTER, FOSTER_PENDING, IN_FOSTER, ADOPTION_PENDING, ADOPTED]

  belongs_to :user
  belongs_to :dog
end
