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
#  required         :boolean          default(FALSE)
#  displayable      :boolean          default(FALSE)
#

class Question < ApplicationRecord
  MULTI_SELECT = 'multiselect'
  MULTIPLE_CHOICE = 'multiple_choice'
  SHORT_TEXT = 'short_text'
  LONG_TEXT = 'long_text'
  COUNT = 'count'
  BOOLEAN = 'boolean'

  FORMATS = [MULTI_SELECT, MULTIPLE_CHOICE, SHORT_TEXT, LONG_TEXT, COUNT, BOOLEAN]

  validates :question_type, inclusion: { in: FORMATS }
  validates_presence_of :question_choices, if: :multiple_answer?
  validates_presence_of :uuid, :slug, :question_text, :question_type, :survey
  validates_uniqueness_of :slug, :index, scope: :survey_id, allow_blank: true

  before_validation :ensure_uuid, :ensure_slug_format
  before_save :set_question_choices, if: :boolean?

  belongs_to :survey

  def self.ordered_for_survey
    order("index ASC")
  end

  def self.displayable
    where(displayable: true)
  end

  def boolean?
    question_type == BOOLEAN
  end

  def multiple_answer?
    [MULTI_SELECT, MULTIPLE_CHOICE].include?(question_type)
  end

  private

  def ensure_slug_format
    self.slug = slug.parameterize.underscore
  end

  def ensure_uuid
    self.uuid ||= SecureRandom.uuid
  end

  def set_question_choices
    self.question_choices = ['true', 'false']
  end
end
