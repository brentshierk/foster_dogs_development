# == Schema Information
#
# Table name: questions
#
#  id               :integer          not null, primary key
#  uuid             :uuid
#  slug             :string           not null
#  description      :string
#  question_text    :text             not null
#  question_type    :string           not null
#  question_subtext :text
#  question_choices :text             default([]), is an Array
#  queryable        :boolean          default(FALSE)
#  survey_id        :integer          not null
#  index            :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Question < ApplicationRecord
  before_validation :ensure_uuid

  private

  def ensure_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
