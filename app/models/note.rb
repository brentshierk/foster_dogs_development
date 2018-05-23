# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  note       :text
#  author     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Note < ApplicationRecord
  belongs_to :user
  # belongs_to :author, class_name: 'User' # TODO: do to this later when we have "admin users"
end
