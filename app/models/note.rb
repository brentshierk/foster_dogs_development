# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  author_id  :integer
#  note       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Note < ActiveRecord::Base
  belongs_to :user
  belongs_to :author, class_name: 'User'
end
