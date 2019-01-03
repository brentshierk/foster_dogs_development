# == Schema Information
#
# Table name: outreaches_users
#
#  outreach_id :bigint(8)        not null
#  user_id     :bigint(8)        not null
#  id          :integer          not null, primary key
#

class OutreachesUser < ApplicationRecord
  belongs_to :outreach
  belongs_to :user
end
