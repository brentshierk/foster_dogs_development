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

  context 'boolean' do
    subject { FactoryBot.build(:question, :boolean) }

    it 'sets the question_choices' do
      expect(subject.question_choices.present?).to be_falsey
      subject.question_type = Question::BOOLEAN
      subject.save!
      expect(subject.reload.question_choices).to eq(['true', 'false'])
    end
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

  describe '#ensure_slug_format' do
    it 'sanitizes the slug' do
      subject.slug = "Foo Bar"
      subject.save!
      expect(subject.slug).to eq('foo_bar')
    end

    it 'keeps the slug if it is in correct format' do
      subject.slug = "foo_bar"
      subject.save!
      expect(subject.slug).to eq('foo_bar')
    end
  end
end
