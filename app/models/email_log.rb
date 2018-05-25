class EmailLog < ApplicationRecord
  belongs_to :user

  validates_presence_of :subject, :user_id
end
