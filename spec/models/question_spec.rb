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

require 'rails_helper'

describe Question, type: :model do
  subject { FactoryBot.build(:question) }

  it 'has a survey' do
    expect(subject).to respond_to(:survey)
  end

  it 'validates question_type' do
    subject.question_type = 'foo'
    expect(subject.valid?).to be_falsey
    subject.question_type = Question::SHORT_TEXT
    expect(subject.valid?).to be_truthy
  end

  context 'multiselect' do
    before do
      subject.question_type = Question::MULTI_SELECT
    end

    it 'validates presence of question_choices' do
      subject.question_choices = []
      expect(subject.valid?).to be_falsey
      subject.question_choices = ['foo', 'bar']
      expect(subject.valid?).to be_truthy
    end

    context '#multiple_answer?' do
      it 'returns true' do
        expect(subject.multiple_answer?).to be_truthy
      end
    end
  end

  context 'multiple choice' do
    before do
      subject.question_type = Question::MULTIPLE_CHOICE
    end

    it 'validates presence of question_choices' do
      subject.question_choices = []
      expect(subject.valid?).to be_falsey
      subject.question_choices = ['foo', 'bar']
      expect(subject.valid?).to be_truthy
    end

    context '#multiple_answer?' do
      it 'returns true' do
        expect(subject.multiple_answer?).to be_truthy
      end
    end
  end
end
