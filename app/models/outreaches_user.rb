# == Schema Information
#
# Table name: outreaches_users
#
#  outreach_id :bigint(8)        not null
#  user_id     :bigint(8)        not null
#

class OutreachesUser < ApplicationRecord
  belongs_to :outreach
  belongs_to :user
end
