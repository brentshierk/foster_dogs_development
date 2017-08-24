# == Schema Information
#
# Table name: email_logs
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  subject    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class EmailLog < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :subject, :user_id
end
