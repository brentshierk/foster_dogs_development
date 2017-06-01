# == Schema Information
#
# Table name: addresses
#
#  id         :integer          not null, primary key
#  line_one   :string
#  line_two   :string
#  city       :string
#  zip        :string
#  latitude   :decimal(, )
#  longitude  :decimal(, )
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Address < ActiveRecord::Base
  belongs_to :user
end
